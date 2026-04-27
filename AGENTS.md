# Agent Guide

This repository is currently operated in agent-assisted `preclean` mode.

## Read First

1. `04_workflow/13_Agent_Team_Workflow.md`
2. `.codex/README.md`
3. `04_workflow/10_Git_Flow.md`
4. `04_workflow/11_Issue_Flow.md`
5. `CLAUDE.md` when the active team is Claude

## Current Phase Lock

- Current phase: `preclean`
- Allowed work: docs, backlog refinement, harness, CI/environment, repo cleanup
- Forbidden work: application code, solution/project generation, product test implementation

## Team Topology

- The repository root checkout is the shared control checkout.
- The control checkout is for shared docs, policy, harness, and environment setup only.
- Team worktrees live under `.worktrees/claude/*` and `.worktrees/codex/*`.
- One issue or SPEC maps to one owning team and one worktree.

## Codex Workflow

- Run `.\.codex\scripts\Initialize-Codex.ps1`
- Inspect active worktrees with `.\.codex\scripts\Get-TeamWorktreeStatus.ps1`
- Create an approved worktree with `.\.codex\scripts\New-TeamWorktree.ps1`
- Use `.codex/templates/HANDOFF_TEMPLATE.md` for handoff notes

## Guardrails

- Do not write app code from the control checkout.
- Do not reuse another team's worktree.
- Do not change `.codex/config/harness.json` phase without explicit approval.
- Commit the shared control-plane baseline before creating the first team worktree.
