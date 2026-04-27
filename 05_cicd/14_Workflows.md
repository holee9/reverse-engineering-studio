# 14. GitHub Actions Workflows

## ci.yml

**경로**: `.github/workflows/ci.yml`

```yaml
name: CI

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

env:
  DOTNET_VERSION: '8.0.x'
  BUILD_CONFIG: 'Release'
  DOTNET_NOLOGO: 'true'
  DOTNET_CLI_TELEMETRY_OPTOUT: 'true'

jobs:
  build-and-test:
    name: Build & Test
    runs-on: windows-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Cache NuGet packages
        uses: actions/cache@v4
        with:
          path: ~/.nuget/packages
          key: ${{ runner.os }}-nuget-${{ hashFiles('**/packages.lock.json', '**/Directory.Packages.props') }}
          restore-keys: |
            ${{ runner.os }}-nuget-

      - name: Restore
        run: dotnet restore

      - name: Format Check
        run: dotnet format --verify-no-changes --no-restore

      - name: Build
        run: dotnet build --configuration ${{ env.BUILD_CONFIG }} --no-restore

      - name: Test
        run: >
          dotnet test
          --configuration ${{ env.BUILD_CONFIG }}
          --no-build
          --logger "trx;LogFileName=test-results.trx"
          --collect:"XPlat Code Coverage"
          --results-directory ./TestResults

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: test-results
          path: ./TestResults/**/*.trx

      - name: Upload coverage
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: ./TestResults/**/coverage.cobertura.xml

      - name: Publish test report
        if: always()
        uses: dorny/test-reporter@v1
        with:
          name: .NET Tests
          path: ./TestResults/**/*.trx
          reporter: dotnet-trx
```

---

## release.yml

**경로**: `.github/workflows/release.yml`

```yaml
name: Release

on:
  push:
    tags:
      - 'v*.*.*'

env:
  DOTNET_VERSION: '8.0.x'
  BUILD_CONFIG: 'Release'
  RID: 'win-x64'

jobs:
  build-release:
    name: Build Release Artifacts
    runs-on: windows-latest

    permissions:
      contents: write  # GitHub Release 생성용

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Extract version
        id: version
        shell: pwsh
        run: |
          $tag = "${{ github.ref_name }}"
          $version = $tag -replace '^v',''
          echo "version=$version" >> $env:GITHUB_OUTPUT

      - name: Restore
        run: dotnet restore

      - name: Run tests (regression)
        run: dotnet test --configuration ${{ env.BUILD_CONFIG }}

      - name: Publish CLI
        run: >
          dotnet publish src/RevEngStudio.Cli/RevEngStudio.Cli.csproj
          -c ${{ env.BUILD_CONFIG }}
          -r ${{ env.RID }}
          --self-contained true
          -p:PublishSingleFile=true
          -p:PublishReadyToRun=true
          -p:IncludeNativeLibrariesForSelfExtract=true
          -p:Version=${{ steps.version.outputs.version }}
          -o ./publish/cli

      - name: Publish WPF (if exists)
        id: wpf-publish
        continue-on-error: true
        run: >
          dotnet publish src/RevEngStudio.Wpf/RevEngStudio.Wpf.csproj
          -c ${{ env.BUILD_CONFIG }}
          -r ${{ env.RID }}
          --self-contained true
          -p:PublishSingleFile=true
          -p:PublishReadyToRun=true
          -p:IncludeNativeLibrariesForSelfExtract=true
          -p:Version=${{ steps.version.outputs.version }}
          -o ./publish/wpf

      - name: Package CLI
        shell: pwsh
        run: |
          Compress-Archive -Path ./publish/cli/* -DestinationPath ./RevEngStudio.Cli-v${{ steps.version.outputs.version }}-${{ env.RID }}.zip

      - name: Package WPF
        if: steps.wpf-publish.outcome == 'success'
        shell: pwsh
        run: |
          Compress-Archive -Path ./publish/wpf/* -DestinationPath ./RevEngStudio.Wpf-v${{ steps.version.outputs.version }}-${{ env.RID }}.zip

      - name: Generate release notes from CHANGELOG
        id: notes
        shell: pwsh
        run: |
          $version = "${{ steps.version.outputs.version }}"
          $changelog = Get-Content CHANGELOG.md -Raw
          $pattern = "(?s)## \[$version\].*?(?=## \[|\z)"
          $match = [regex]::Match($changelog, $pattern)
          if ($match.Success) {
            $notes = $match.Value
            $notes | Out-File -FilePath release-notes.md -Encoding UTF8
          } else {
            "Release v$version" | Out-File -FilePath release-notes.md -Encoding UTF8
          }

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: ${{ github.ref_name }}
          name: Release ${{ github.ref_name }}
          body_path: release-notes.md
          draft: false
          prerelease: ${{ contains(github.ref_name, '-') }}
          files: |
            RevEngStudio.Cli-v${{ steps.version.outputs.version }}-${{ env.RID }}.zip
            RevEngStudio.Wpf-v${{ steps.version.outputs.version }}-${{ env.RID }}.zip
```

---

## Issue Template 파일

### `.github/ISSUE_TEMPLATE/epic.yml`

```yaml
name: Epic
description: Large feature unit containing multiple tasks
title: "[Epic] "
labels: ["epic"]
body:
  - type: textarea
    id: description
    attributes:
      label: Description
      description: What does this epic accomplish?
    validations:
      required: true

  - type: textarea
    id: goals
    attributes:
      label: Goals
      description: Measurable outcomes
      placeholder: |
        - Goal 1
        - Goal 2
    validations:
      required: true

  - type: textarea
    id: tasks
    attributes:
      label: Child Tasks
      description: Link child task issues (created separately)
      placeholder: |
        - [ ] #N Task 1
        - [ ] #N Task 2

  - type: dropdown
    id: level
    attributes:
      label: Level
      options:
        - L1 — Surface Scan
        - L2 — Signature Extract
        - L3 — Structure Map
        - L4 — Behavior Analysis
        - L5 — Document Synthesis
    validations:
      required: true
```

### `.github/ISSUE_TEMPLATE/task.yml`

```yaml
name: Task
description: Standard work unit (2-8 hours)
title: "[Task] "
labels: ["task"]
body:
  - type: textarea
    id: what
    attributes:
      label: What
      description: Concretely, what needs to be done?
    validations:
      required: true

  - type: textarea
    id: why
    attributes:
      label: Why
      description: Why is this task needed?
    validations:
      required: true

  - type: textarea
    id: dod
    attributes:
      label: Definition of Done
      description: Check all that apply when complete
      value: |
        - [ ] Implementation complete
        - [ ] Unit tests added/updated
        - [ ] All tests pass locally
        - [ ] CI passes
        - [ ] Self-reviewed
      render: markdown
    validations:
      required: true

  - type: input
    id: estimate
    attributes:
      label: Estimate
      placeholder: "e.g., 2h, 4h, 1d"
    validations:
      required: true

  - type: input
    id: parent
    attributes:
      label: Parent Epic
      placeholder: "#123"

  - type: dropdown
    id: level
    attributes:
      label: Level
      options:
        - L1
        - L2
        - L3
        - L4
        - L5
    validations:
      required: true

  - type: dropdown
    id: area
    attributes:
      label: Area
      multiple: true
      options:
        - core
        - analysis
        - cli
        - wpf
        - export
        - infra
        - ci
        - test
        - docs

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - high
        - medium
        - low
    validations:
      required: true
```

### `.github/ISSUE_TEMPLATE/bug.yml`

```yaml
name: Bug
description: Something isn't working
title: "[Bug] "
labels: ["bug"]
body:
  - type: textarea
    id: description
    attributes:
      label: Description
    validations:
      required: true

  - type: textarea
    id: reproduce
    attributes:
      label: Steps to Reproduce
      placeholder: |
        1.
        2.
        3.
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Actual Behavior
    validations:
      required: true

  - type: input
    id: version
    attributes:
      label: Version
      placeholder: "v0.1.0"
    validations:
      required: true
```

### `.github/ISSUE_TEMPLATE/spike.yml`

```yaml
name: Spike
description: Timeboxed exploratory investigation
title: "[Spike] "
labels: ["spike"]
body:
  - type: textarea
    id: question
    attributes:
      label: Question to Answer
    validations:
      required: true

  - type: input
    id: timebox
    attributes:
      label: Timebox
      placeholder: "e.g., 1 day, 4 hours"
    validations:
      required: true

  - type: textarea
    id: approach
    attributes:
      label: Approach
      description: How will you investigate?

  - type: textarea
    id: output
    attributes:
      label: Expected Output
      description: PoC code, decision doc, etc.
    validations:
      required: true
```
