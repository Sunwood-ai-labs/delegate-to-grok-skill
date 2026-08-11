$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$skillRoot = Join-Path $repoRoot 'skill'
$wrapper = Join-Path $skillRoot 'scripts\invoke-grok.ps1'
$syncScript = Join-Path $repoRoot 'scripts\sync-skill.ps1'

$tokens = $null
$parseErrors = $null
[void][System.Management.Automation.Language.Parser]::ParseFile($wrapper, [ref]$tokens, [ref]$parseErrors)
if ($parseErrors.Count -gt 0) {
    $messages = $parseErrors | ForEach-Object { $_.Message }
    throw "PowerShell parser errors: $($messages -join '; ')"
}

$skillText = Get-Content -LiteralPath (Join-Path $skillRoot 'SKILL.md') -Raw
if ($skillText -notmatch '(?s)^---\s*\r?\nname:\s*delegate-to-grok\s*\r?\ndescription:\s*.+?\r?\n---') {
    throw 'SKILL.md frontmatter is missing the required name or description.'
}
if ($skillText -match '(?m)^\s*&?\s*grok\s+-p\b') {
    throw 'SKILL.md must not contain a direct grok -p invocation.'
}
if ((Get-Content -LiteralPath $wrapper -Raw) -notmatch "'--no-plan'") {
    throw 'The wrapper must disable Grok plan mode by default.'
}

$help = & $wrapper -Help
if (($help -join [Environment]::NewLine) -notmatch 'working-directory-only') {
    throw 'The wrapper help path did not return the expected safe-default summary.'
}

$outside = Join-Path ([System.IO.Path]::GetTempPath()) 'delegate-to-grok-outside-root'
New-Item -ItemType Directory -Path $outside -Force | Out-Null
try {
    try {
        & $wrapper -WorkingDirectory $outside -AllowedRoot $skillRoot -Prompt 'must not reach Grok' -OutputFormat text
        throw 'Out-of-bound working directory was not rejected before Grok invocation.'
    } catch {
        if ($_.Exception.Message -notmatch 'GROK_CWD_DENIED') { throw }
    }
} finally {
    Remove-Item -LiteralPath $outside -Force -ErrorAction SilentlyContinue
}

$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('delegate-to-grok-verify-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $testRoot -Force | Out-Null
try {
    $installedSkill = Join-Path $testRoot 'installed-skill'
    & $syncScript -Destination $installedSkill
    & $syncScript -Destination $installedSkill -VerifyOnly

    $installedWrapper = Join-Path $installedSkill 'scripts\invoke-grok.ps1'
    $tokens = $null
    $parseErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($installedWrapper, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors.Count -gt 0) { throw "Installed wrapper parser errors: $(($parseErrors | ForEach-Object Message) -join '; ')" }

    $mockGrok = Join-Path $testRoot 'mock-grok.cmd'
    [System.IO.File]::WriteAllText($mockGrok, @'
@echo off
if /I "%~1"=="models" (
  echo You are logged in
  echo Available models:
  exit /b 0
)
setlocal EnableDelayedExpansion
set "promptFile="
:arguments
if "%~1"=="" goto writeLog
if /I "%~1"=="--prompt-file" (
  set "promptFile=%~2"
  shift
)
shift
goto arguments
:writeLog
(
  echo %*
  echo ---PROMPT---
  type "!promptFile!"
) > "%DELEGATE_GROK_TEST_LOG%"
if /I "%DELEGATE_GROK_TEST_MODE%"=="stderr-exit" (
  echo controlled stderr 1>&2
  exit /b 17
)
echo MOCK_OK
'@, [System.Text.UTF8Encoding]::new($false))

    $mockHome = Join-Path $testRoot 'grok-home'
    New-Item -ItemType Directory -Path $mockHome -Force | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $mockHome 'auth.json'), '{}', [System.Text.UTF8Encoding]::new($false))
    $env:DELEGATE_GROK_TEST_LOG = Join-Path $testRoot 'mock.log'
    $env:DELEGATE_GROK_TEST_MODE = 'success'
    $probe = "Return exactly READY. Keep FL2V, H3 and 日本語`nwith a second line as literal prompt text."
    $result = & $installedWrapper -WorkingDirectory $testRoot -Prompt $probe -MaxTurns 1 -GrokHome $mockHome -GrokExecutable $mockGrok
    if (($result -join "`n") -notmatch 'MOCK_OK') { throw 'The staged wrapper did not return the mock result.' }
    $captured = Get-Content -LiteralPath $env:DELEGATE_GROK_TEST_LOG -Raw
    if ($captured -notmatch '(?s)--prompt-file.*--no-plan') { throw 'The staged wrapper did not pass --prompt-file and --no-plan.' }
    if ($captured -notmatch [regex]::Escape($probe)) { throw 'The staged wrapper did not preserve punctuation, Japanese, and newlines in the prompt file.' }

    $env:DELEGATE_GROK_TEST_MODE = 'stderr-exit'
    try {
        & $installedWrapper -WorkingDirectory $testRoot -Prompt 'controlled failure' -MaxTurns 1 -GrokHome $mockHome -GrokExecutable $mockGrok
        throw 'A nonzero mock Grok exit was accepted.'
    } catch {
        if ($_.Exception.Message -notmatch 'GROK_INVOKE_FAILED: Grok Build exited with code 17') { throw }
    }
} finally {
    Remove-Item Env:DELEGATE_GROK_TEST_LOG -ErrorAction SilentlyContinue
    Remove-Item Env:DELEGATE_GROK_TEST_MODE -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $testRoot -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Output 'Repository verification passed.'
