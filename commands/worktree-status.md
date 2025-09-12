# Worktree Status Command

Shows the current status of all 5 worktrees including git status, branch info, and recent changes.

## Usage

```bash
cd /Users/pedro.figueiredo/Documents/git/neon/agent && ./scripts/worktree-status.sh
```

## Description

This command provides a comprehensive overview of all parallel agent worktrees:

1. **Lists all active worktrees** with their branches and commit status
2. **Shows git status** for each worktree (modified files, staged changes, etc.)
3. **Displays recent commits** made by each agent
4. **Shows tmux session status** if agents are currently running
5. **Reports log file locations** and sizes

## Sample Output

```
🔍 Worktree Status Report
========================

📁 Active Worktrees:
/path/to/agent-worktrees/agent-1  abc1234 [experiment/agent-1] 
/path/to/agent-worktrees/agent-2  abc1234 [experiment/agent-2] +2 -1
...

🔄 Git Status Summary:
Agent 1: Clean working tree
Agent 2: 3 modified files, 1 untracked
Agent 3: 2 staged changes
...

💻 Tmux Sessions:
parallel-agents: 5 windows (active)

📊 Recent Activity:
Agent 1: Last commit 2 hours ago
Agent 2: Currently working...
```

## Prerequisites

- Worktrees must be created with `@worktree-init` first