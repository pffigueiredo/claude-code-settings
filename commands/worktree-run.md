# Worktree Run Command

Run the same prompt on 5 Claude agents in parallel using tmux.

Each agent works in its own isolated worktree, allowing you to compare different approaches to solving the same problem.

## Usage

```bash
cd /Users/pedro.figueiredo/Documents/git/neon/agent && ./scripts/run-parallel-agents.sh "your prompt here"
```

## Description

This command:

1. **Creates a tmux session** with 5 panes, each showing a different agent
2. **Sets up each pane** in its respective worktree directory (agent-1 through agent-5)
3. **Displays the prompt** and prepares each pane for Claude execution
4. **Auto-attaches** to the tmux session so you can watch all agents simultaneously

## Example

```bash
# Run the same prompt on all 5 agents
@worktree-run "implement a REST API for a todo application with CRUD operations"
```

## Tmux Controls

Once attached to the session:
- `Ctrl+B, arrow keys` - Navigate between panes
- `Ctrl+B, z` - Zoom into current pane (press again to zoom out)
- `Ctrl+B, d` - Detach from session (agents keep running)
- `tmux attach -t parallel-agents` - Re-attach to session

## Prerequisites

- Run `@worktree-init` first to create the worktrees
- Ensure tmux is installed: `brew install tmux`

## Logs

Execution logs are saved to `logs/parallel-run-YYYYMMDD-HHMMSS/` for later analysis.