[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet("claude", "codex")]
    [string]$Team,

    [Parameter(Mandatory)]
    [string]$Type,

    [Parameter(Mandatory)]
    [string]$Identifier,

    [Parameter(Mandatory)]
    [string]$Slug,

    [string]$BaseBranch,
    [switch]$DryRun,
    [switch]$AllowDirty
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$configPath = Join-Path $repoRoot ".codex\config\harness.json"
$config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json

$allowedBranchTypes = @($config.branchTypes)
if ($Type -notin $allowedBranchTypes) {
    throw "Unsupported branch type '$Type'. Allowed values: $($allowedBranchTypes -join ', ')"
}

$phasePolicy = $config.phasePolicies.$($config.phase)
$phaseAllowedTypes = @($phasePolicy.allowedBranchTypes)
if ($Type -notin $phaseAllowedTypes) {
    throw "Branch type '$Type' is not allowed in phase '$($config.phase)'. Allowed values: $($phaseAllowedTypes -join ', ')"
}

$statusLines = @(& git status --porcelain)
if ((-not $AllowDirty) -and $statusLines.Count -gt 0) {
    throw "Working tree is not clean. Commit the shared control-plane baseline before creating a team worktree."
}

$selectedBaseBranch = if ($BaseBranch) { $BaseBranch } else { $config.baseBranch }

$null = & git rev-parse --verify $selectedBaseBranch 2>$null
if ($LASTEXITCODE -ne 0) {
    throw "Base branch '$selectedBaseBranch' does not exist locally."
}

$sanitizedIdentifier = ($Identifier.Trim() -replace "[^A-Za-z0-9._-]+", "-").Trim("-")
$sanitizedSlug = ($Slug.Trim().ToLowerInvariant() -replace "[^a-z0-9]+", "-").Trim("-")

if ([string]::IsNullOrWhiteSpace($sanitizedIdentifier)) {
    throw "Identifier is empty after sanitization."
}

if ([string]::IsNullOrWhiteSpace($sanitizedSlug)) {
    throw "Slug is empty after sanitization."
}

$branchName = "{0}/{1}-{2}" -f $Type, $sanitizedIdentifier, $sanitizedSlug
$existingBranch = (& git branch --list $branchName | Out-String).Trim()
if (-not [string]::IsNullOrWhiteSpace($existingBranch)) {
    throw "Branch already exists: $branchName"
}

$teamRootRelative = $config.teams.$Team.worktreePath
$teamRoot = Join-Path $repoRoot $teamRootRelative
$worktreePath = Join-Path $teamRoot ("{0}-{1}" -f $sanitizedIdentifier, $sanitizedSlug)

if (Test-Path -LiteralPath $worktreePath) {
    throw "Worktree path already exists: $worktreePath"
}

$summary = [ordered]@{
    Team = $Team
    Phase = $config.phase
    Branch = $branchName
    BaseBranch = $selectedBaseBranch
    WorktreePath = $worktreePath
    HandoffTemplate = $config.teams.$Team.handoffTemplate
}

if ($DryRun) {
    $summary.GetEnumerator() | ForEach-Object {
        Write-Host ("{0}: {1}" -f $_.Key, $_.Value)
    }
    return
}

if (-not (Test-Path -LiteralPath $teamRoot)) {
    New-Item -ItemType Directory -Path $teamRoot -Force | Out-Null
}

& git worktree add "$worktreePath" -b "$branchName" "$selectedBaseBranch"
if ($LASTEXITCODE -ne 0) {
    throw "git worktree add failed for $branchName"
}

Write-Host "Team worktree created." -ForegroundColor Green
$summary.GetEnumerator() | ForEach-Object {
    Write-Host ("{0}: {1}" -f $_.Key, $_.Value)
}
