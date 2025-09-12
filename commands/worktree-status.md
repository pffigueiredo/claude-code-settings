# Worktree Status Command

Display comprehensive status of all 5 worktrees and the parallel agent system.

Shows current state, activity, and quick action suggestions.

## Usage

```bash
cd /Users/pedro.figueiredo/Documents/git/neon/agent
./scripts/status-worktrees.sh
```

## Description

This command provides a complete overview of your parallel development setup:

### System Status
- **Tmux session** - Whether `parallel-agents` is running
- **Git worktrees** - List of active worktrees
- **Quick actions** - Suggested next steps

### Per-Worktree Details
For each agent (1-5):
- **Location and branch** - Worktree path and git branch
- **Working tree status** - Modified, added, deleted files
- **Commit history** - Commits ahead of main branch
- **Last activity** - Most recently modified file

### Summary Statistics
- **Active worktrees** - How many are set up (X/5)
- **Worktrees with changes** - How many have modifications
- **Total commits** - Commits across all agents

## Example Output

```
📊 Worktree Status Report
=========================

🖥️  Tmux Session:
  ✅ Session 'parallel-agents' is running
  📺 Attach with: tmux attach -t parallel-agents

🌲 Git Worktrees:
/path/to/agent                           706bb5b [igor/data_apps_template]
/path/to/agent-worktrees/agent-1         abc1234 [experiment/agent-1]
/path/to/agent-worktrees/agent-2         def5678 [experiment/agent-2]
...

--- Agent 1 ---
📍 Location: /path/to/agent-worktrees/agent-1
🌿 Branch: experiment/agent-1
🔄 Working tree changes:
   M  src/api.py
   A  src/models.py
📝 Commits ahead of main: 2
   Latest: feat: add REST API endpoints
⏰ Last modified: api.py at Dec 12 10:30:00
```

## Status Indicators

- ✅ **Active/Good** - Component is working properly
- 🔄 **Active** - Has changes or activity
- ⭕ **Inactive** - Not running or clean state
- ❌ **Error** - Missing or broken component

## Quick Actions

The status report includes suggested next steps:
- `@worktree-run "prompt"` - Run prompt on all agents
- `@worktree-compare` - Compare agent results  
- `@worktree-clean` - Clean up everything

## Use Cases

- **Health check** - Verify setup is working
- **Progress tracking** - See which agents are active
- **Decision making** - Determine next steps
- **Troubleshooting** - Identify missing components