[CmdletBinding()]
param(
    [ValidateSet("all", "claude", "codex", "control")]
    [string]$Team = "all",
    [switch]$AsJson
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$null = Get-Content -LiteralPath (Join-Path $repoRoot ".codex\config\harness.json") -Raw | ConvertFrom-Json

$porcelain = @(& git worktree list --porcelain)

$entries = @()
$current = @{}

foreach ($line in $porcelain) {
    if ([string]::IsNullOrWhiteSpace($line)) {
        if ($current.Count -gt 0) {
            $entries += [pscustomobject]$current
            $current = @{}
        }
        continue
    }

    $parts = $line -split " ", 2
    $key = $parts[0]
    $value = if ($parts.Count -gt 1) { $parts[1] } else { $true }
    $current[$key] = $value
}

if ($current.Count -gt 0) {
    $entries += [pscustomobject]$current
}

$items = foreach ($entry in $entries) {
    $path = $entry.worktree
    $normalized = $path.Replace("\", "/")
    $ownerTeam = "control"

    if ($normalized -like "*/.worktrees/codex/*") {
        $ownerTeam = "codex"
    }
    elseif ($normalized -like "*/.worktrees/claude/*") {
        $ownerTeam = "claude"
    }

    [pscustomobject]@{
        Team = $ownerTeam
        Branch = if ($entry.branch) { $entry.branch -replace "^refs/heads/", "" } else { "(detached)" }
        Head = $entry.HEAD
        Path = $path
    }
}

if ($Team -ne "all") {
    $items = $items | Where-Object { $_.Team -eq $Team }
}

if ($AsJson) {
    $items | ConvertTo-Json -Depth 4
    return
}

if (-not $items) {
    Write-Host "No worktrees found for filter: $Team" -ForegroundColor Yellow
    return
}

$items | Sort-Object Team, Branch | Format-Table Team, Branch, Head, Path -AutoSize
