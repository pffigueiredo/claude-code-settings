# Worktree Clean Command

Safely cleans up all worktrees, branches, and associated resources created by the parallel agent system.

## Usage

```bash
~/.claude/scripts/worktree-clean.sh
```

## Description

This command performs comprehensive cleanup:

1. **Stops running agents** - Kills any active tmux sessions
2. **Removes worktrees** - Deletes all agent worktree directories
3. **Cleans branches** - Removes experiment branches (with confirmation)
4. **Archives logs** - Moves log files to archive directory with timestamp
5. **Resets environment** - Returns to clean state for next experiment

## Safety Features

- **Interactive confirmations** for destructive operations
- **Backup option** - Can archive worktree contents before deletion
- **Selective cleanup** - Choose what to clean (branches, worktrees, logs, etc.)
- **Undo capability** - Maintains archive for recovery if needed

## Cleanup Options

```bash
# Full cleanup (interactive)
@worktree-clean

# Clean only worktrees, keep branches
@worktree-clean --keep-branches

# Clean everything without confirmation (dangerous!)
@worktree-clean --force

# Archive before cleaning
@worktree-clean --archive
```

## Sample Output

```
🧹 Worktree Cleanup
==================

Found the following resources:
✓ 5 active worktrees
✓ 5 experiment branches  
✓ 1 active tmux session (parallel-agents)
✓ 3 log directories

⚠️  This will permanently delete:
- /path/to/agent-worktrees/agent-* (5 directories)
- experiment/agent-* branches (5 branches)
- tmux session: parallel-agents

Continue? [y/N]: 

🗄️  Archiving logs to: archives/experiment-20231201-143022/
✅ Cleanup completed successfully!
```

## Recovery

If you need to recover deleted work:
- Check `archives/` directory for saved logs and diffs
- Use `git reflog` to recover deleted branches
- Worktree contents are not recoverable unless archived

## Prerequisites

- Can be run at any time, even with active agents running
