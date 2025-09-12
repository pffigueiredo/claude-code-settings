# Worktree Init Command

Initialize 5 git worktrees for parallel development with Claude agents.

Creates 5 independent worktrees, each with its own branch based on your **current branch**:
- `agent-worktrees/agent-1` (branch: `experiment/agent-1`)
- `agent-worktrees/agent-2` (branch: `experiment/agent-2`)
- `agent-worktrees/agent-3` (branch: `experiment/agent-3`)
- `agent-worktrees/agent-4` (branch: `experiment/agent-4`)
- `agent-worktrees/agent-5` (branch: `experiment/agent-5`)

## Usage

```bash
cd /Users/pedro.figueiredo/Documents/git/neon/agent && ./scripts/setup-worktrees.sh
```

## Description

This command sets up the infrastructure for running 5 parallel Claude instances on the same codebase. Each worktree is completely isolated, allowing different agents to work independently without conflicts.

**Important:** The worktrees will be created based on whatever branch you're currently on. If you want to experiment from a feature branch, make sure you're on that branch before running this command.

After initialization, use:
- `@worktree-run "your prompt"` to execute the same prompt on all 5 agents
- `@worktree-status` to check the current state
- `@worktree-compare` to analyze the different approaches
- `@worktree-clean` to clean up everything

The worktrees are created outside the main repository to avoid conflicts with the main development workflow.