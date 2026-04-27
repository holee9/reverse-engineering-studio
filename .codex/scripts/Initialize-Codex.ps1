[CmdletBinding()]
param(
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$configPath = Join-Path $repoRoot ".codex\config\harness.json"

if (-not (Test-Path -LiteralPath $configPath)) {
    throw "Harness config not found: $configPath"
}

$config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
$runtimeRoot = Join-Path $repoRoot $config.runtimeRoot

$requiredDirs = @(
    $runtimeRoot,
    (Join-Path $runtimeRoot "logs"),
    (Join-Path $runtimeRoot "state"),
    (Join-Path $runtimeRoot "tmp"),
    (Join-Path $repoRoot $config.worktreeRoot),
    (Join-Path $repoRoot $config.teams.claude.worktreePath),
    (Join-Path $repoRoot $config.teams.codex.worktreePath)
)

foreach ($dir in $requiredDirs) {
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

function Get-ToolStatus {
    param([string]$Name)

    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        return "not-found"
    }

    return $command.Source
}

$gitVersion = try {
    (& git --version)
}
catch {
    "git not found"
}

$gitStatusLines = @(& git status --porcelain)
$sharedBaselineClean = $gitStatusLines.Count -eq 0
$phasePolicy = $config.phasePolicies.$($config.phase)
$allowedTypes = @($phasePolicy.allowedBranchTypes) -join ", "

$status = [ordered]@{
    RepoRoot = $repoRoot
    CurrentPhase = $config.phase
    BaseBranch = $config.baseBranch
    ControlCheckout = $config.controlCheckout.path
    RuntimeRoot = $runtimeRoot
    WorktreeRoot = Join-Path $repoRoot $config.worktreeRoot
    SharedBaselineClean = $sharedBaselineClean
    PendingGitEntries = $gitStatusLines.Count
    Git = $gitVersion
    Codex = Get-ToolStatus -Name "codex"
    GitHubCli = Get-ToolStatus -Name "gh"
}

if (-not $Quiet) {
    Write-Host "Codex harness initialized." -ForegroundColor Green

    foreach ($item in $status.GetEnumerator()) {
        Write-Host ("{0}: {1}" -f $item.Key, $item.Value)
    }

    Write-Host ("Allowed branch types in this phase: {0}" -f $allowedTypes) -ForegroundColor Yellow

    if (-not $sharedBaselineClean) {
        Write-Host "Shared baseline is dirty. Commit the control-plane changes before creating the first team worktree." -ForegroundColor Yellow
    }

    Write-Host "Next:" -ForegroundColor Cyan
    Write-Host "  1. Review AGENTS.md and 04_workflow/13_Agent_Team_Workflow.md"
    Write-Host "  2. Run .\.codex\scripts\Get-TeamWorktreeStatus.ps1"
    Write-Host "  3. Create a team worktree only after the shared baseline is committed"
}
