$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$skillRoot = Join-Path $repoRoot 'skill'
$wrapper = Join-Path $skillRoot 'scripts\invoke-grok.ps1'

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

Write-Output 'Repository verification passed.'
