[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet("claude", "codex")]
    [string]$Team,

    [Parameter(Mandatory)]
    [Alias("WorkType")]
    [string]$Type,

    [Parameter(Mandatory)]
    [Alias("IssueId")]
    [string]$Identifier,

    [Parameter(Mandatory)]
    [Alias("Name")]
    [string]$Slug,

    [string]$BaseBranch,
    [switch]$DryRun,
    [switch]$AllowDirty
)

$ErrorActionPreference = "Stop"
$utf8Output = New-Object System.Text.UTF8Encoding $false
[Console]::OutputEncoding = $utf8Output
$OutputEncoding = $utf8Output

$TextMap = @{
    UnsupportedBranchType = "7KeA7JuQ7ZWY7KeAIOyViuuKlCDruIzrnpzsuZgg7YOA7J6F7J6F64uI64ukOiAnezB9Jy4g7ZeI7Jqp6rCSOiB7MX0="
    DisallowedByPhase = "7ZiE7J6sIHBoYXNlICd7MH0n7JeQ7ISc64qUIOu4jOuenOy5mCDtg4DsnoUgJ3sxfSfsnYQg7IKs7Jqp7ZWgIOyImCDsl4bsirXri4jri6QuIO2XiOyaqeqwkjogezJ9"
    DirtyWorkingTree = "d29ya2luZyB0cmVl6rCAIOygleumrOuQmOyngCDslYrslZjsirXri4jri6QuIO2MgCB3b3JrdHJlZeulvCDrp4zrk6TquLAg7KCE7JeQIOqzteyaqSDsoJzslrTrqbQgYmFzZWxpbmXsnYQg66i87KCAIOy7pOuwi+2VtOyVvCDtlanri4jri6Qu"
    MissingBaseBranch = "6riw7KSAIOu4jOuenOy5mCAnezB9J+qwgCDroZzsu6zsl5Ag7JeG7Iq164uI64ukLg=="
    EmptyIdentifier = "7KCV66asIO2bhCBJZGVudGlmaWVyIOqwkuydtCDruYTslrQg7J6I7Iq164uI64ukLg=="
    EmptySlug = "7KCV66asIO2bhCBTbHVnIOqwkuydtCDruYTslrQg7J6I7Iq164uI64ukLg=="
    ExistingBranch = "7J2066+4IOyhtOyerO2VmOuKlCDruIzrnpzsuZjsnoXri4jri6Q6IHswfQ=="
    ExistingWorktree = "7J2066+4IOyhtOyerO2VmOuKlCB3b3JrdHJlZSDqsr3roZzsnoXri4jri6Q6IHswfQ=="
    Team = "7YyA"
    CurrentPhase = "7ZiE7J6sIHBoYXNl"
    Branch = "67iM656c7LmY"
    BaseBranch = "6riw7KSAIOu4jOuenOy5mA=="
    WorktreePath = "d29ya3RyZWUg6rK966Gc"
    HandoffTemplate = "aGFuZG9mZiB0ZW1wbGF0ZQ=="
    WorktreeAddFailed = "ezB9IOu4jOuenOy5mOydmCBnaXQgd29ya3RyZWUgYWRkIOyLpO2VieyXkCDsi6TtjKjtlojsirXri4jri6Qu"
    WorktreeCreated = "7YyAIHdvcmt0cmVl66W8IOyDneyEse2WiOyKteuLiOuLpC4="
}

function Get-Text {
    param([Parameter(Mandatory)][string]$Key)

    return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($TextMap[$Key]))
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$configPath = Join-Path $repoRoot ".codex\config\harness.json"
$config = Get-Content -LiteralPath $configPath -Raw -Encoding utf8 | ConvertFrom-Json

$allowedBranchTypes = @($config.branchTypes)
if ($Type -notin $allowedBranchTypes) {
    throw ((Get-Text -Key "UnsupportedBranchType") -f $Type, ($allowedBranchTypes -join ", "))
}

$phasePolicy = $config.phasePolicies.$($config.phase)
$phaseAllowedTypes = @($phasePolicy.allowedBranchTypes)
if ($Type -notin $phaseAllowedTypes) {
    throw ((Get-Text -Key "DisallowedByPhase") -f $config.phase, $Type, ($phaseAllowedTypes -join ", "))
}

$statusLines = @(& git -c core.excludesFile=.git/info/exclude status --porcelain)
if ((-not $AllowDirty) -and $statusLines.Count -gt 0) {
    throw (Get-Text -Key "DirtyWorkingTree")
}

$selectedBaseBranch = if ($BaseBranch) { $BaseBranch } else { $config.baseBranch }

$null = & git rev-parse --verify $selectedBaseBranch 2>$null
if ($LASTEXITCODE -ne 0) {
    throw ((Get-Text -Key "MissingBaseBranch") -f $selectedBaseBranch)
}

$sanitizedIdentifier = ($Identifier.Trim() -replace "[^A-Za-z0-9._-]+", "-").Trim("-")
$sanitizedSlug = ($Slug.Trim().ToLowerInvariant() -replace "[^a-z0-9]+", "-").Trim("-")

if ([string]::IsNullOrWhiteSpace($sanitizedIdentifier)) {
    throw (Get-Text -Key "EmptyIdentifier")
}

if ([string]::IsNullOrWhiteSpace($sanitizedSlug)) {
    throw (Get-Text -Key "EmptySlug")
}

$branchName = "{0}/{1}-{2}" -f $Type, $sanitizedIdentifier, $sanitizedSlug
$existingBranch = (& git branch --list $branchName | Out-String).Trim()
if (-not [string]::IsNullOrWhiteSpace($existingBranch)) {
    throw ((Get-Text -Key "ExistingBranch") -f $branchName)
}

$teamRootRelative = $config.teams.$Team.worktreePath
$teamRoot = Join-Path $repoRoot $teamRootRelative
$worktreePath = Join-Path $teamRoot ("{0}-{1}" -f $sanitizedIdentifier, $sanitizedSlug)

if (Test-Path -LiteralPath $worktreePath) {
    throw ((Get-Text -Key "ExistingWorktree") -f $worktreePath)
}

$summary = @(
    @{ Label = (Get-Text -Key "Team"); Value = $Team },
    @{ Label = (Get-Text -Key "CurrentPhase"); Value = $config.phase },
    @{ Label = (Get-Text -Key "Branch"); Value = $branchName },
    @{ Label = (Get-Text -Key "BaseBranch"); Value = $selectedBaseBranch },
    @{ Label = (Get-Text -Key "WorktreePath"); Value = $worktreePath },
    @{ Label = (Get-Text -Key "HandoffTemplate"); Value = $config.teams.$Team.handoffTemplate }
)

if ($DryRun) {
    $summary | ForEach-Object {
        Write-Host ("{0}: {1}" -f $_.Label, $_.Value)
    }
    return
}

if (-not (Test-Path -LiteralPath $teamRoot)) {
    New-Item -ItemType Directory -Path $teamRoot -Force | Out-Null
}

& git worktree add "$worktreePath" -b "$branchName" "$selectedBaseBranch"
if ($LASTEXITCODE -ne 0) {
    throw ((Get-Text -Key "WorktreeAddFailed") -f $branchName)
}

Write-Host (Get-Text -Key "WorktreeCreated") -ForegroundColor Green
$summary | ForEach-Object {
    Write-Host ("{0}: {1}" -f $_.Label, $_.Value)
}
