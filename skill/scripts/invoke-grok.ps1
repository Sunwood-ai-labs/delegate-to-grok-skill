[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ParameterSetName = 'Run')]
    [ValidateNotNullOrEmpty()]
    [string]$Prompt,
    [string]$WorkingDirectory = (Get-Location).Path,
    [ValidateRange(1, 50)]
    [int]$MaxTurns = 8,
    [ValidateSet('low', 'medium', 'high')]
    [string]$ReasoningEffort = 'low',
    # `text` appeared in historical callers; keep it as a safe alias for plain.
    [ValidateSet('plain', 'text', 'json', 'streaming-json')]
    [string]$OutputFormat = 'plain',
    # Default to the exact target. A broader root is always an explicit opt-in.
    [string[]]$AllowedRoot = @(),
    # Ignore an ambient GROK_HOME. Custom homes must be passed explicitly.
    [string]$GrokHome = (Join-Path $env:USERPROFILE '.grok'),
    # Test seam for a staged-package mock. Normal callers leave this empty.
    [string]$GrokExecutable = '',
    [ValidateRange(0, 600)]
    [int]$LockTimeoutSeconds = 30,
    [switch]$AllowSubagents,
    [switch]$AllowMemory,
    [switch]$AllowWrites,
    [Parameter(ParameterSetName = 'Help')]
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help) {
    @'
Usage:
  invoke-grok.ps1 -WorkingDirectory <directory> -Prompt <text> [options]

Safe defaults: read-only, working-directory-only, no Grok subagents, no plan
mode, no cross-session memory, and a 30-second single-run lock. Use -AllowWrites only
when the user explicitly requested file changes. Use -AllowedRoot only for a
confirmed broader root. Output formats: plain (or compatibility alias text), json,
streaming-json.
'@ | Write-Output
    return
}

function Test-PathWithinRoot {
    param([Parameter(Mandatory = $true)][string]$Candidate, [Parameter(Mandatory = $true)][string]$Root)
    $normalizedCandidate = [System.IO.Path]::GetFullPath($Candidate).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    $normalizedRoot = [System.IO.Path]::GetFullPath($Root).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    $comparison = [System.StringComparison]::OrdinalIgnoreCase
    return $normalizedCandidate.Equals($normalizedRoot, $comparison) -or $normalizedCandidate.StartsWith($normalizedRoot + [System.IO.Path]::DirectorySeparatorChar, $comparison)
}

function Resolve-GrokExecutable {
    param([string]$RequestedExecutable)
    if (-not [string]::IsNullOrWhiteSpace($RequestedExecutable)) {
        if (Test-Path -LiteralPath $RequestedExecutable -PathType Leaf) { return (Resolve-Path -LiteralPath $RequestedExecutable).Path }
        throw "GROK_NOT_FOUND: explicit Grok executable was not found: $RequestedExecutable"
    }
    $canonicalExe = Join-Path $env:USERPROFILE '.grok\bin\grok.exe'
    if (Test-Path -LiteralPath $canonicalExe -PathType Leaf) { return (Resolve-Path -LiteralPath $canonicalExe).Path }
    $pathCommand = Get-Command grok -CommandType Application -ErrorAction SilentlyContinue
    if ($pathCommand -and (Test-Path -LiteralPath $pathCommand.Source -PathType Leaf)) { return (Resolve-Path -LiteralPath $pathCommand.Source).Path }
    throw 'GROK_NOT_FOUND: grok.exe was not found in the canonical user install location or PATH.'
}

function Invoke-GrokProcess {
    param([Parameter(Mandatory = $true)][string]$Executable, [Parameter(Mandatory = $true)][string[]]$Arguments)
    # stderr from a native process becomes a PowerShell ErrorRecord on Windows
    # PowerShell 5.1. Keep it private and normalize failures by exit code below.
    $previousErrorActionPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = @(& $Executable @Arguments 2>&1 | ForEach-Object { $_.ToString() })
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }
    return [PSCustomObject]@{ Output = $output; ExitCode = $exitCode }
}

function Test-GrokAuthentication {
    param([Parameter(Mandatory = $true)][string]$Executable, [Parameter(Mandatory = $true)][string]$Stage)
    # Keep raw CLI diagnostics private: they can contain account details.
    $result = Invoke-GrokProcess -Executable $Executable -Arguments @('models')
    $resultText = ($result.Output | Out-String)
    if ($resultText -match '(?i)\b(not logged in|not authenticated|authentication required|login required|unauthorized|forbidden)\b') {
        throw "GROK_AUTH_NEEDED: $Stage preflight reports that authentication is required. The wrapper did not start login. Follow the skill OAuth single-flight procedure, then retry once."
    }
    $hasLoginConfirmation = $resultText -match '(?im)^\s*You are logged in\b'
    $hasModelList = $resultText -match '(?im)^\s*Available models:'
    if ($result.ExitCode -ne 0 -or -not $hasLoginConfirmation -or -not $hasModelList) {
        throw "GROK_AUTH_UNKNOWN: $Stage preflight could not positively verify the Grok session. Exit code: $($result.ExitCode). Stop instead of retrying or starting another login."
    }
}

$resolvedDirectory = (Resolve-Path -LiteralPath $WorkingDirectory -ErrorAction Stop).Path
if (-not (Test-Path -LiteralPath $resolvedDirectory -PathType Container)) { throw "GROK_CWD_INVALID: working directory is not a directory: $resolvedDirectory" }
$allowedRootInputs = if ($AllowedRoot.Count -gt 0) { $AllowedRoot } else { @($resolvedDirectory) }
$resolvedAllowedRoots = @(
    foreach ($root in $allowedRootInputs) {
        if (-not (Test-Path -LiteralPath $root -PathType Container)) { throw "GROK_ALLOWED_ROOT_INVALID: allowed root is not a directory: $root" }
        (Resolve-Path -LiteralPath $root).Path
    }
)
if (-not ($resolvedAllowedRoots | Where-Object { Test-PathWithinRoot -Candidate $resolvedDirectory -Root $_ })) { throw "GROK_CWD_DENIED: $resolvedDirectory is outside the allowed root set. Pass the exact approved root with -AllowedRoot." }

$grokExe = Resolve-GrokExecutable -RequestedExecutable $GrokExecutable
if (-not (Test-Path -LiteralPath $GrokHome -PathType Container)) { throw "GROK_AUTH_MISSING: Grok home does not exist: $GrokHome" }
$canonicalGrokHome = (Resolve-Path -LiteralPath $GrokHome).Path
$canonicalAuthPath = Join-Path $canonicalGrokHome 'auth.json'
$effectiveOutputFormat = if ($OutputFormat -eq 'text') { 'plain' } else { $OutputFormat }
$runMutex = [System.Threading.Mutex]::new($false, 'Local\CodexDelegateToGrokRun')
$mutexHeld = $false
$tempGrokHome = $null
$previousGrokHome = $env:GROK_HOME
$previousDisableAutoUpdater = $env:GROK_DISABLE_AUTOUPDATER

try {
    try { $mutexHeld = $runMutex.WaitOne([System.TimeSpan]::FromSeconds($LockTimeoutSeconds)) }
    catch [System.Threading.AbandonedMutexException] { $mutexHeld = $true }
    if (-not $mutexHeld) { throw "GROK_BUSY: another delegate-to-grok invocation remained active for $LockTimeoutSeconds seconds. Do not launch a second Grok process; wait for or inspect the existing run." }
    if (-not (Test-Path -LiteralPath $canonicalAuthPath -PathType Leaf)) {
        throw @"
GROK_AUTH_MISSING: $canonicalAuthPath was not found.
This wrapper never runs 'grok login' or 'grok logout'. Complete the skill OAuth
single-flight procedure, verify it with 'grok models', then invoke this wrapper once.
"@
    }
    # Canonical authentication changes only after a successful run and postflight.
    $tempGrokHome = Join-Path ([System.IO.Path]::GetTempPath()) ('grok-delegate-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $tempGrokHome -Force | Out-Null
    $tempAuthPath = Join-Path $tempGrokHome 'auth.json'
    Copy-Item -LiteralPath $canonicalAuthPath -Destination $tempAuthPath -Force
    $env:GROK_HOME = $tempGrokHome
    $env:GROK_DISABLE_AUTOUPDATER = '1'
    Test-GrokAuthentication -Executable $grokExe -Stage 'pre-invocation'
    $guard = if ($AllowWrites) {
@'
Apply only the requested changes inside the specified working directory. Preserve unrelated changes. Do not commit, push, change branches, publish, install dependencies, run grok login/logout, or use destructive commands unless the request explicitly requires it.
'@
    } else {
@'
This is a read-only task. Do not create, edit, rename, or delete files. Do not install dependencies, run builds or tests that create artifacts, perform Git write operations, run grok login/logout, or change authentication. If a change is needed, explain it without applying it.
'@
    }
    $promptPath = Join-Path $tempGrokHome 'prompt.txt'
    [System.IO.File]::WriteAllText($promptPath, "$guard`n`n$Prompt", [System.Text.UTF8Encoding]::new($false))
    $arguments = @('--cwd', $resolvedDirectory, '--max-turns', [string]$MaxTurns, '--reasoning-effort', $ReasoningEffort, '--output-format', $effectiveOutputFormat, '--permission-mode', $(if ($AllowWrites) { 'auto' } else { 'default' }), '--prompt-file', $promptPath, '--no-plan')
    if (-not $AllowWrites) { $arguments += @('--sandbox', 'read-only') }
    if (-not $AllowSubagents) { $arguments += '--no-subagents' }
    if (-not $AllowMemory) { $arguments += '--no-memory' }
    $taskResult = Invoke-GrokProcess -Executable $grokExe -Arguments $arguments
    if ($taskResult.ExitCode -ne 0) { throw "GROK_INVOKE_FAILED: Grok Build exited with code $($taskResult.ExitCode). Canonical authentication was not changed." }
    $taskResult.Output | Write-Output
    if (-not (Test-Path -LiteralPath $tempAuthPath -PathType Leaf)) { throw 'GROK_AUTH_LOST: isolated auth.json disappeared; canonical authentication was preserved.' }
    Test-GrokAuthentication -Executable $grokExe -Stage 'post-invocation'
    Copy-Item -LiteralPath $tempAuthPath -Destination $canonicalAuthPath -Force
} finally {
    if ($null -eq $previousGrokHome) { Remove-Item Env:GROK_HOME -ErrorAction SilentlyContinue } else { $env:GROK_HOME = $previousGrokHome }
    if ($null -eq $previousDisableAutoUpdater) { Remove-Item Env:GROK_DISABLE_AUTOUPDATER -ErrorAction SilentlyContinue } else { $env:GROK_DISABLE_AUTOUPDATER = $previousDisableAutoUpdater }
    if ($tempGrokHome -and (Test-Path -LiteralPath $tempGrokHome)) { Remove-Item -LiteralPath $tempGrokHome -Recurse -Force -ErrorAction SilentlyContinue }
    if ($mutexHeld) { $runMutex.ReleaseMutex() }
    $runMutex.Dispose()
}
