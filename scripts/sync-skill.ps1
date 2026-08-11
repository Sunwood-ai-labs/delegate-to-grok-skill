[CmdletBinding()]
param(
    [string]$Destination = (Join-Path $env:USERPROFILE '.codex\skills\delegate-to-grok'),
    [switch]$VerifyOnly
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$sourceRoot = Join-Path $repoRoot 'skill'
$payload = @('SKILL.md', 'agents\openai.yaml', 'scripts\invoke-grok.ps1')

function Get-PayloadManifest {
    param([Parameter(Mandatory = $true)][string]$Root)
    foreach ($relativePath in $payload) {
        $path = Join-Path $Root $relativePath
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "PAYLOAD_MISSING: $path" }
        [PSCustomObject]@{ Path = $relativePath; Sha256 = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash }
    }
}

function Assert-PayloadMatch {
    param([Parameter(Mandatory = $true)][string]$ExpectedRoot, [Parameter(Mandatory = $true)][string]$ActualRoot)
    $expected = @(Get-PayloadManifest -Root $ExpectedRoot)
    $actual = @(Get-PayloadManifest -Root $ActualRoot)
    foreach ($file in $expected) {
        $actualFile = $actual | Where-Object Path -eq $file.Path
        if (-not $actualFile -or $actualFile.Sha256 -ne $file.Sha256) { throw "PAYLOAD_MISMATCH: $($file.Path)" }
    }
}

if ($VerifyOnly) {
    if (-not (Test-Path -LiteralPath $Destination -PathType Container)) { throw "PAYLOAD_MISMATCH: installed skill is missing: $Destination" }
    Assert-PayloadMatch -ExpectedRoot $sourceRoot -ActualRoot $Destination
    Write-Output "Installed skill payload matches source: $Destination"
    return
}

$resolvedDestination = [System.IO.Path]::GetFullPath($Destination)
$destinationParent = [System.IO.Path]::GetDirectoryName($resolvedDestination)
$destinationLeaf = [System.IO.Path]::GetFileName($resolvedDestination)
$Destination = $resolvedDestination
New-Item -ItemType Directory -Path $destinationParent -Force | Out-Null
$mutex = [System.Threading.Mutex]::new($false, 'Local\CodexDelegateToGrokRun')
$mutexHeld = $false
$stage = Join-Path $destinationParent ('.' + $destinationLeaf + '.stage-' + [guid]::NewGuid().ToString('N'))
$backup = $null

try {
    $mutexHeld = $mutex.WaitOne([System.TimeSpan]::Zero)
    if (-not $mutexHeld) { throw 'GROK_BUSY: cannot replace the installed skill while a delegate-to-grok run is active.' }
    New-Item -ItemType Directory -Path $stage -Force | Out-Null
    foreach ($relativePath in $payload) {
        $sourcePath = Join-Path $sourceRoot $relativePath
        $stagePath = Join-Path $stage $relativePath
        New-Item -ItemType Directory -Path ([System.IO.Path]::GetDirectoryName($stagePath)) -Force | Out-Null
        Copy-Item -LiteralPath $sourcePath -Destination $stagePath -Force
    }
    $tokens = $null
    $parseErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile((Join-Path $stage 'scripts\invoke-grok.ps1'), [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors.Count -gt 0) { throw "PAYLOAD_INVALID: $($parseErrors[0].Message)" }
    Assert-PayloadMatch -ExpectedRoot $sourceRoot -ActualRoot $stage

    if (Test-Path -LiteralPath $Destination) {
        $backup = Join-Path $destinationParent ('.' + $destinationLeaf + '.backup-' + (Get-Date -Format 'yyyyMMddHHmmss'))
        Move-Item -LiteralPath $Destination -Destination $backup
    }
    Move-Item -LiteralPath $stage -Destination $Destination
    Assert-PayloadMatch -ExpectedRoot $sourceRoot -ActualRoot $Destination
    Write-Output "Installed skill payload synchronized: $Destination"
    if ($backup) { Write-Output "Previous payload retained at: $backup" }
} catch {
    if ($backup -and -not (Test-Path -LiteralPath $Destination) -and (Test-Path -LiteralPath $backup)) { Move-Item -LiteralPath $backup -Destination $Destination }
    throw
} finally {
    if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue }
    if ($mutexHeld) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
}
