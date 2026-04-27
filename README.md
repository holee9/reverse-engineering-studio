# RevEng Studio

Document-first repository for a personal Windows tool that analyzes legacy DLLs and turns the findings into development-ready documentation.

## Project Summary

- Goal: extract structure, signatures, imports/exports, and behavioral clues from Windows DLLs
- Target UX: drag a DLL, inspect the results, export reusable documentation
- Target stack: C# / WPF / .NET 8 / GitHub Actions
- Delivery approach: level-based incremental releases from `v0.1` to `v1.0`

This repository is currently in `preclean` phase.

- Focus now: repository cleanup, workflow alignment, harness/bootstrap setup, and backlog refinement
- Not allowed now: app code implementation, solution generation, product test implementation

## Current Repository Role

The repository root is not an implementation worktree yet. It is the shared control checkout used for:

- project documentation
- team workflow policy
- Claude/Codex bootstrap and harness files
- CI and environment setup

Actual implementation work will be done in team worktrees after this baseline is committed.

## Team Operating Model

Two agent teams operate on the same repository:

- `Claude team`: uses `CLAUDE.md`, `.claude/`, and `.moai/`
- `Codex team`: uses `AGENTS.md` and `.codex/`

Shared rules:

- one issue or SPEC maps to one owner team
- one owner team maps to one worktree
- the root checkout is for shared control-plane changes only
- team worktrees live under `.worktrees/claude/` and `.worktrees/codex/`

Primary workflow reference:

- [04_workflow/13_Agent_Team_Workflow.md](04_workflow/13_Agent_Team_Workflow.md)

## Repository Map

### Product and planning docs

- [00_README.md](00_README.md): top-level document index and reading order
- [01_overview/00_README.md](01_overview/00_README.md): product overview
- [01_overview/01_Methodology.md](01_overview/01_Methodology.md): incremental development methodology
- [01_overview/02_Levels.md](01_overview/02_Levels.md): release levels `L1` to `L5`
- [02_backlog/03_Roadmap.md](02_backlog/03_Roadmap.md): roadmap
- [02_backlog/04_Backlog_L1.md](02_backlog/04_Backlog_L1.md): immediate backlog

### Architecture

- [03_architecture/07_Architecture.md](03_architecture/07_Architecture.md): architecture overview
- [03_architecture/08_Modules.md](03_architecture/08_Modules.md): module boundaries
- [03_architecture/09_Tech_Stack.md](03_architecture/09_Tech_Stack.md): stack decisions

### Workflow and templates

- [04_workflow/10_Git_Flow.md](04_workflow/10_Git_Flow.md): branch and merge rules
- [04_workflow/11_Issue_Flow.md](04_workflow/11_Issue_Flow.md): issue lifecycle
- [04_workflow/12_Labels.md](04_workflow/12_Labels.md): labels and milestones
- [04_workflow/13_Agent_Team_Workflow.md](04_workflow/13_Agent_Team_Workflow.md): Claude/Codex team worktree policy
- [05_cicd/13_CI_Strategy.md](05_cicd/13_CI_Strategy.md): CI strategy
- [06_templates/16_PR_Template.md](06_templates/16_PR_Template.md): PR template
- [06_templates/17_Commit_Convention.md](06_templates/17_Commit_Convention.md): commit convention

### Agent bootstrap

- [AGENTS.md](AGENTS.md): Codex-facing repo instructions
- [CLAUDE.md](CLAUDE.md): Claude-facing repo instructions
- [.codex/README.md](.codex/README.md): Codex bootstrap guide
- [.codex/config/harness.json](.codex/config/harness.json): phase and worktree policy

## Quick Start

### For document review

Read in this order:

1. [00_README.md](00_README.md)
2. [01_overview/00_README.md](01_overview/00_README.md)
3. [01_overview/01_Methodology.md](01_overview/01_Methodology.md)
4. [01_overview/02_Levels.md](01_overview/02_Levels.md)
5. [04_workflow/10_Git_Flow.md](04_workflow/10_Git_Flow.md)
6. [05_cicd/13_CI_Strategy.md](05_cicd/13_CI_Strategy.md)

### For Codex team setup

```powershell
powershell -ExecutionPolicy Bypass -File .\.codex\scripts\Initialize-Codex.ps1
powershell -ExecutionPolicy Bypass -File .\.codex\scripts\Get-TeamWorktreeStatus.ps1
```

### For team worktree creation

Only after the shared baseline is committed:

```powershell
powershell -ExecutionPolicy Bypass -File .\.codex\scripts\New-TeamWorktree.ps1 `
  -Team codex `
  -Type docs `
  -Identifier 101 `
  -Slug preclean-harness
```

## Planned Product Levels

- `L1 Surface Scan`: PE metadata and CLI analysis
- `L2 Signature Extract`: managed type/signature extraction with minimal WPF UI
- `L3 Structure Map`: relationship and call graph visualization
- `L4 Behavior Analysis`: Ghidra-assisted native analysis
- `L5 Document Synthesis`: Markdown/Word report generation

## Git and Release Policy

- `main` must remain releasable
- no `develop` branch
- work is branched from `main`
- PR-first workflow with CI gates
- default merge strategy is squash merge

See:

- [04_workflow/10_Git_Flow.md](04_workflow/10_Git_Flow.md)
- [05_cicd/13_CI_Strategy.md](05_cicd/13_CI_Strategy.md)

## Current Baseline Status

This repository is still establishing its first shared control-plane baseline. Until that baseline is committed and pushed:

- worktree creation is intentionally blocked by the Codex harness
- team implementation work should not start
- root-level changes should stay limited to docs, workflow, and environment setup
