# Audits an agent folder against the Agent Standard (STANDARD.md): checks that every one of the
# 8 blocks exists and that the fields required for the agent's tier and stage are filled.
# This checks completeness only. The advisor does the judgment review afterwards.
#   powershell -ExecutionPolicy Bypass -File deploy/audit-agent.ps1 -Path <agent folder> [-Save | -Out report.md]
#   -Save writes <agent folder>/reviews/standards-audit-YYYY-MM-DD.md; without -Save/-Out it only prints.
# The framework is read-only: the script refuses to write anything inside the agent-standards folder.
# Exit code: 0 = no block missing or empty, 1 = at least one block MISSING, NOT STARTED or BLOCKED,
# 2 = folder has no AGENT.md (not a skeleton layout: map the 8 blocks instead, see AUDIT.md)
# (task not Green Light), or a refused write.

param(
    [Parameter(Mandatory = $true)][string]$Path,
    [string]$Out,
    [switch]$Save
)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$standardsRoot = [System.IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot)).TrimEnd('\') + '\'

if ($Save -and -not $Out) {
    $Out = Join-Path (Join-Path $Path 'reviews') ("standards-audit-{0}.md" -f (Get-Date -Format 'yyyy-MM-dd'))
}
if ($Out) {
    if (-not [System.IO.Path]::IsPathRooted($Out)) { $Out = Join-Path (Get-Location).Path $Out }
    $Out = [System.IO.Path]::GetFullPath($Out)
    $target = $Out
    if ($target.StartsWith($standardsRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-Output "REFUSED: $target is inside the agent-standards framework, which is read-only. Save audit reports in the agent's own folder (e.g. <agent>/reviews/)."
        exit 1
    }
}

function Read-Lines([string]$file) {
    if (Test-Path -LiteralPath $file) { return [System.IO.File]::ReadAllLines($file, $utf8) }
    return $null
}

function Get-Section([string[]]$lines, [int]$number) {
    $start = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^##\s+$number\.\s") { $start = $i; break }
    }
    if ($start -lt 0) { return $null }
    $end = $lines.Count
    for ($j = $start + 1; $j -lt $lines.Count; $j++) {
        if ($lines[$j] -match '^##\s') { $end = $j; break }
    }
    return $lines[$start..($end - 1)]
}

# Which tags count for a tier. [if: ...] fields always count: fill them or mark N/A (reason).
function Test-Applicable([string]$line, [string]$tier) {
    if ($line -match '\[if:') { return $true }
    if ($line -match '\[C\]') { return ($tier -eq 'Critical') }
    if ($line -match '\[S\]') { return ($tier -eq 'Standard' -or $tier -eq 'Critical') }
    if ($line -match '\[L\]') { return $true }
    return $false
}

function Measure-Fields([string[]]$lines, [string]$tier) {
    $total = 0; $open = @()
    foreach ($l in $lines) {
        if ($l -notmatch '\[(L|S|C)\]|\[if:') { continue }
        if (-not (Test-Applicable $l $tier)) { continue }
        $total++
        if ($l -match 'TODO') {
            $label = ($l -replace '^\s*[-|]\s*', '' -replace '\*\*', '' -replace '\s+', ' ').Trim()
            if ($label.Length -gt 90) { $label = $label.Substring(0, 90) + '...' }
            $open += $label
        }
    }
    return @{ Total = $total; Open = $open }
}

$agentFile = Join-Path $Path 'AGENT.md'
if (-not (Test-Path -LiteralPath $agentFile)) {
    Write-Output "This folder has no AGENT.md, so it doesn't follow the skeleton layout yet."
    Write-Output "Map its existing files onto the 8 blocks instead (AUDIT.md step 3, done by your AI),"
    Write-Output "or start from the skeleton: copy skeleton/ into the folder and fill it in."
    exit 2
}
$agent = Read-Lines $agentFile
$results = @()
$tier = 'Lite'; $stage = 'Design'; $headerIssues = @()

if ($agent) {
    $t = ($agent | Where-Object { $_ -match '^\*\*Tier:\*\*' } | Select-Object -First 1)
    if ($t -match '(Lite|Standard|Critical)' -and $t -notmatch 'TODO') { $tier = $Matches[1] }
    else { $headerIssues += 'Tier not set (audited as Lite)' }
    $s = ($agent | Where-Object { $_ -match '^\*\*Stage:\*\*' } | Select-Object -First 1)
    if ($s -match '\*\*Stage:\*\*\s*(Design|MVP|Pilot|Scale)') { $stage = $Matches[1] }
}

$blocks = @(
    @{ N = 1; Name = 'Purpose';        File = 'AGENT.md';            Section = 1 },
    @{ N = 2; Name = 'Steps';          File = 'AGENT.md';            Section = 2; Extra = 'PROMPT.md' },
    @{ N = 3; Name = 'Input';          File = 'io\INPUT.md';         Section = 0; Extra = 'knowledge\README.md' },
    @{ N = 4; Name = 'Output';         File = 'io\OUTPUT.md';        Section = 0 },
    @{ N = 5; Name = 'Tools & Access'; File = 'AGENT.md';            Section = 5 },
    @{ N = 6; Name = 'Controls';       File = 'AGENT.md';            Section = 6 },
    @{ N = 7; Name = 'Evals & DQ';     File = 'evals\EVAL-PLAN.md';  Section = 0 },
    @{ N = 8; Name = 'Operations';     File = 'AGENT.md';            Section = 8 }
)

$minGolden = @{ Design = 0; MVP = 20; Pilot = 100; Scale = 300 }

foreach ($b in $blocks) {
    $issues = @()
    $lines = Read-Lines (Join-Path $Path $b.File)
    if ($lines -and $b.Section -gt 0) { $lines = Get-Section $lines $b.Section }
    if (-not $lines) {
        $where = if ($b.Section -gt 0) { "$($b.File) (section $($b.Section))" } else { $b.File }
        $results += [pscustomobject]@{ N = $b.N; Block = $b.Name; Status = 'MISSING'; Filled = '-'; Issues = @("$where not found") }
        continue
    }
    $m = Measure-Fields $lines $tier
    $issues += $m.Open

    # Blocks 2 and 3 have a second file: PROMPT.md (instructions) and knowledge/README.md (reference files).
    if ($b.Extra) {
        $extra = Read-Lines (Join-Path $Path $b.Extra)
        if (-not $extra) { $issues += "$($b.Extra) missing" }
        else {
            $mx = Measure-Fields $extra $tier
            $m = @{ Total = $m.Total + $mx.Total; Open = @($m.Open) + @($mx.Open) }
            $issues += $mx.Open
            if ($b.N -eq 2) {
                $inFence = $false; $afterHeading = $false; $placeholder = $false
                foreach ($l in $extra) {
                    if ($l -match '^##\s') { $afterHeading = ($l -match '^##\s+System prompt') }
                    if ($afterHeading -and $l -match '^```') { $inFence = -not $inFence; continue }
                    if ($inFence -and $l.Trim() -eq 'TODO') { $placeholder = $true }
                }
                if ($placeholder) { $issues += 'PROMPT.md: system prompt not written yet' }
            }
            if ($b.N -eq 3) {
                foreach ($l in $extra) {
                    if ($l -notmatch '^\|') { continue }
                    $cell = ($l.Trim().Trim('|').Split('|')[0]).Trim().Trim('`')
                    if ($cell -match '^(File|-+|TODO|N/A.*)?$') { continue }
                    if (-not (Test-Path -LiteralPath (Join-Path (Join-Path $Path 'knowledge') $cell))) {
                        $issues += "knowledge\$cell is listed in knowledge\README.md but not found"
                    }
                }
            }
        }
    }

    if ($b.N -eq 1) {
        $zone = ($lines | Where-Object { $_ -match 'Task selection' } | Select-Object -First 1)
        if ($zone -match 'zone\s+(Red|Low)') { $issues = @('Task is not Green Light (zone: ' + $Matches[1] + '). Do not build') + $issues }
        $issues = $headerIssues + $issues
    }
    if ($b.N -eq 7) {
        $golden = Read-Lines (Join-Path $Path 'evals\GOLDEN-SET.md')
        if (-not $golden) { $issues += 'evals\GOLDEN-SET.md missing' }
        else {
            $count = @($golden | Where-Object { $_ -match '^\|\s*G\d+\s*\|' }).Count
            $need = $minGolden[$stage]
            if ($count -lt $need) { $issues += "Golden set has $count real cases; stage $stage needs $need" }
            elseif ($need -eq 0 -and $count -eq 0) { $issues += 'Golden set is empty (needs 20 real cases before MVP)' }
        }
    }
    if ($b.N -eq 8) {
        foreach ($f in @('CHANGELOG.md', 'DECISIONS.md', 'STATE.md')) {
            if (-not (Test-Path -LiteralPath (Join-Path $Path $f))) { $issues += "$f missing" }
        }
        $state = Read-Lines (Join-Path $Path 'STATE.md')
        if ($state) {
            $resume = ($state | Where-Object { $_ -match 'Resume here' } | Select-Object -First 1)
            if (-not $resume -or $resume -match 'TODO') { $issues += 'STATE.md has no "Resume here" next action' }
        }
        $log = Read-Lines (Join-Path $Path 'CHANGELOG.md')
        if ($log -and $stage -ne 'Design') {
            $released = @($log | Where-Object { $_ -match '^\|\s*\d+\.\d+\.\d+' -and $_ -match '\|\s*good\s*\|' })
            if ($released.Count -eq 0) { $issues += "CHANGELOG.md has no version marked 'good' with a gate (stage $stage)" }
        }
    }

    $filled = if ($m.Total -gt 0) { "$($m.Total - $m.Open.Count)/$($m.Total)" } else { '0/0' }
    $blocked = ($b.N -eq 1 -and ($issues | Where-Object { $_ -match '^Task is not Green Light' }))
    $status =
        if ($blocked) { 'BLOCKED' }
        elseif ($m.Total -gt 0 -and $m.Open.Count -eq $m.Total) { 'NOT STARTED' }
        elseif ($issues.Count -gt 0) { 'GAPS' }
        else { 'PASS' }
    $results += [pscustomobject]@{ N = $b.N; Block = $b.Name; Status = $status; Filled = $filled; Issues = $issues }
}

# Report (Markdown, so it can be saved into the agent's reviews/ folder)
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# Agent audit: $(Split-Path -Leaf (Resolve-Path -LiteralPath $Path))")
[void]$sb.AppendLine('')
[void]$sb.AppendLine("Date: $(Get-Date -Format 'yyyy-MM-dd') | Tier: $tier | Stage: $stage | Completeness only; the judgment review follows.")
[void]$sb.AppendLine('')
[void]$sb.AppendLine('| # | Block | Status | Fields filled |')
[void]$sb.AppendLine('|---|-------|--------|---------------|')
foreach ($r in $results) { [void]$sb.AppendLine("| $($r.N) | $($r.Block) | $($r.Status) | $($r.Filled) |") }
foreach ($r in $results) {
    if ($r.Issues.Count -eq 0) { continue }
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine("## $($r.N). $($r.Block): $($r.Status)")
    foreach ($i in $r.Issues) { [void]$sb.AppendLine("- $i") }
}
$report = $sb.ToString()
Write-Output $report
if ($Out) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent ([System.IO.Path]::GetFullPath($Out))) | Out-Null
    [System.IO.File]::WriteAllText([System.IO.Path]::GetFullPath($Out), $report, $utf8); Write-Output "Saved: $Out"
}

if (@($results | Where-Object { $_.Status -in @('MISSING', 'NOT STARTED', 'BLOCKED') }).Count -gt 0) { exit 1 }
exit 0
