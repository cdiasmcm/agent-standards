# Builds dist/AGENT-STANDARDS-BUNDLE.md: every standard in one file, for LLM tools that take a
# single upload or paste. Run after any change to the standards, before committing.
#   powershell -ExecutionPolicy Bypass -File deploy/build-bundle.ps1

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$out  = Join-Path $root 'dist\AGENT-STANDARDS-BUNDLE.md'

# Order matters: entry point, the standard and the advisor first, then the skeleton (in block order), then the library.
$files = @(
    'START-HERE.md',
    'AUDIT.md',
    'CREATE.md',
    'STANDARD.md',
    'AGENT-PROMPT.md',
    'AGENT-IO.md',
    'skeleton/AGENT.md',
    'skeleton/PROMPT.md',
    'skeleton/io/INPUT.md',
    'skeleton/knowledge/README.md',
    'skeleton/io/OUTPUT.md',
    'skeleton/skills/README.md',
    'skeleton/evals/EVAL-PLAN.md',
    'skeleton/evals/GOLDEN-SET.md',
    'skeleton/CHANGELOG.md',
    'skeleton/DECISIONS.md',
    'skeleton/STATE.md',
    'skeleton/_archive/README.md',
    'FRAMEWORK.md',
    'EVALS.md',
    'PLATFORM.md',
    'PATTERNS.md',
    'PRINCIPLES.md',
    'REGISTRY-TEMPLATE.md'
)

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('# AGENT STANDARDS BUNDLE')
[void]$sb.AppendLine('')
[void]$sb.AppendLine("> Generated $(Get-Date -Format 'yyyy-MM-dd') by deploy/build-bundle.ps1. Do not edit; edit the source files and rebuild.")
[void]$sb.AppendLine('> This single file contains all the standards. Where the text says "read <FILE>.md", use that file''s section below (headed "FILE: <name>").')
[void]$sb.AppendLine('> Sections named skeleton/... are the templates for a new agent: recreate them as separate files in the agent''s folder.')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('## Contents')
foreach ($f in $files) { [void]$sb.AppendLine("- FILE: $f") }

$utf8 = New-Object System.Text.UTF8Encoding($false)
foreach ($f in $files) {
    $path = Join-Path $root $f
    if (-not (Test-Path $path)) { throw "Missing source file: $f" }
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('---')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine("# FILE: $f")
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine([System.IO.File]::ReadAllText($path, $utf8).TrimEnd())
}

New-Item -ItemType Directory -Force -Path (Split-Path $out) | Out-Null
[System.IO.File]::WriteAllText($out, $sb.ToString(), $utf8)
Write-Output "Built $out ($([math]::Round((Get-Item $out).Length / 1KB)) KB, $($files.Count) files)"
