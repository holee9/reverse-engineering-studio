[CmdletBinding()]
param(
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"
$utf8Output = New-Object System.Text.UTF8Encoding $false
[Console]::OutputEncoding = $utf8Output
$OutputEncoding = $utf8Output

$TextMap = @{
    MissingConfig = "aGFybmVzcyBjb25maWcg7YyM7J287J2EIOywvuydhCDsiJgg7JeG7Iq164uI64ukOiB7MH0="
    RepoPath = "7KCA7J6l7IaMIOqyveuhnA=="
    CurrentPhase = "7ZiE7J6sIHBoYXNl"
    BaseBranch = "6riw7KSAIOu4jOuenOy5mA=="
    ControlCheckout = "6rO17JqpIOygnOyWtCBjaGVja291dA=="
    RuntimePath = "65+w7YOA7J6EIOqyveuhnA=="
    WorktreeRoot = "d29ya3RyZWUg66Oo7Yq4"
    BaselineClean = "6rO17JygIGJhc2VsaW5lIOygleumrCDsl6zrtoA="
    PendingGitCount = "64yA6riwIOykkeyduCBHaXQg7ZWt66qpIOyImA=="
    GitHubCli = "R2l0SHViIENMSQ=="
    InitDone = "Q29kZXggaGFybmVzcyDstIjquLDtmZTrpbwg66eI7LOk7Iq164uI64ukLg=="
    AllowedBranchTypes = "7ZiE7J6sIHBoYXNl7JeQ7IScIO2XiOyaqeuQmOuKlCDruIzrnpzsuZgg7YOA7J6FOiB7MH0="
    BaselineWarning = "6rO17JygIGJhc2VsaW5l7J20IOygleumrOuQmOyngCDslYrslZjsirXri4jri6QuIOyyqyDtjIAgd29ya3RyZWXrpbwg66eM65Ok6riwIOyghOyXkCDqs7Xsmqkg7KCc7Ja066m0IOuzgOqyveydhCDrqLzsoIAg7Luk67CL7ZW07JW8IO2VqeuLiOuLpC4="
    NextSteps = "64uk7J2MIOyInOyEnDo="
    Step1 = "ICAxLiBBR0VOVFMubWTsmYAgMDRfd29ya2Zsb3cvMTNfQWdlbnRfVGVhbV9Xb3JrZmxvdy5tZOulvCDqsoDthqDtlanri4jri6Qu"
    Step2 = "ICAyLiAuXC5jb2RleFxzY3JpcHRzXEdldC1UZWFtV29ya3RyZWVTdGF0dXMucHMx66GcIOyDge2DnOulvCDtmZXsnbjtlanri4jri6Qu"
    Step3 = "ICAzLiDqs7XsnKAgYmFzZWxpbmUg7Luk67CLIOydtO2bhOyXkOunjCDtjIAgd29ya3RyZWXrpbwg7IOd7ISx7ZWp64uI64ukLg=="
}

function Get-Text {
    param([Parameter(Mandatory)][string]$Key)

    return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($TextMap[$Key]))
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$configPath = Join-Path $repoRoot ".codex\config\harness.json"

if (-not (Test-Path -LiteralPath $configPath)) {
    throw ((Get-Text -Key "MissingConfig") -f $configPath)
}

$config = Get-Content -LiteralPath $configPath -Raw -Encoding utf8 | ConvertFrom-Json
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

$gitStatusLines = @(& git -c core.excludesFile=.git/info/exclude status --porcelain)
$sharedBaselineClean = $gitStatusLines.Count -eq 0
$phasePolicy = $config.phasePolicies.$($config.phase)
$allowedTypes = @($phasePolicy.allowedBranchTypes) -join ", "

$status = @(
    @{ Label = (Get-Text -Key "RepoPath"); Value = $repoRoot },
    @{ Label = (Get-Text -Key "CurrentPhase"); Value = $config.phase },
    @{ Label = (Get-Text -Key "BaseBranch"); Value = $config.baseBranch },
    @{ Label = (Get-Text -Key "ControlCheckout"); Value = $config.controlCheckout.path },
    @{ Label = (Get-Text -Key "RuntimePath"); Value = $runtimeRoot },
    @{ Label = (Get-Text -Key "WorktreeRoot"); Value = (Join-Path $repoRoot $config.worktreeRoot) },
    @{ Label = (Get-Text -Key "BaselineClean"); Value = $sharedBaselineClean },
    @{ Label = (Get-Text -Key "PendingGitCount"); Value = $gitStatusLines.Count },
    @{ Label = "Git"; Value = $gitVersion },
    @{ Label = "Codex"; Value = (Get-ToolStatus -Name "codex") },
    @{ Label = (Get-Text -Key "GitHubCli"); Value = (Get-ToolStatus -Name "gh") }
)

if (-not $Quiet) {
    Write-Host (Get-Text -Key "InitDone") -ForegroundColor Green

    foreach ($item in $status) {
        Write-Host ("{0}: {1}" -f $item.Label, $item.Value)
    }

    Write-Host ((Get-Text -Key "AllowedBranchTypes") -f $allowedTypes) -ForegroundColor Yellow

    if (-not $sharedBaselineClean) {
        Write-Host (Get-Text -Key "BaselineWarning") -ForegroundColor Yellow
    }

    Write-Host (Get-Text -Key "NextSteps") -ForegroundColor Cyan
    Write-Host (Get-Text -Key "Step1")
    Write-Host (Get-Text -Key "Step2")
    Write-Host (Get-Text -Key "Step3")
}
