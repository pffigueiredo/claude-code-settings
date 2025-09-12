# Worktree Clean Command

Clean up all 5 worktrees, branches, and associated resources.

Completely removes the parallel development setup and returns to a clean state.

## Usage

```bash
cd /Users/pedro.figueiredo/Documents/git/neon/agent
./scripts/cleanup-worktrees.sh
```

## Description

This command performs a thorough cleanup:

### Automatic Cleanup
- **Kills tmux session** `parallel-agents` if running
- **Removes all worktrees** (agent-1 through agent-5)
- **Deletes experiment branches** (`experiment/agent-1` through `experiment/agent-5`)
- **Removes empty directories** (agent-worktrees folder if empty)

### Interactive Cleanup
Prompts you to also remove:
- **Logs directory** (`logs/`) - All execution logs from parallel runs
- **Reports directory** (`reports/`) - All comparison reports

## What Gets Cleaned

```
# Always removed:
../agent-worktrees/agent-1/     # Worktree directory
../agent-worktrees/agent-2/     # Worktree directory  
../agent-worktrees/agent-3/     # Worktree directory
../agent-worktrees/agent-4/     # Worktree directory
../agent-worktrees/agent-5/     # Worktree directory
experiment/agent-1              # Git branch
experiment/agent-2              # Git branch
experiment/agent-3              # Git branch
experiment/agent-4              # Git branch
experiment/agent-5              # Git branch

# Optionally removed (with confirmation):
logs/                           # Execution logs
reports/                        # Comparison reports
```

## Safety Features

- **Confirmation prompts** for optional cleanup
- **Force removal** of worktrees even if they have uncommitted changes
- **Graceful handling** of missing worktrees or branches
- **Status report** showing what was cleaned

## Use Cases

- **After experimentation** - Clean up when done comparing approaches
- **Before new experiment** - Start fresh for a new parallel run
- **Disk space cleanup** - Remove accumulated logs and reports
- **Reset environment** - Return to original repository state

## Recovery

After cleanup, you can start over with:
```bash
@worktree-init    # Re-create the 5 worktrees
```

**⚠️ Warning**: This permanently deletes all work in the worktrees. Make sure to merge any valuable changes back to main branches before cleaning up.