#!/bin/bash

# Show status of all worktrees and parallel agents

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKTREES_DIR="$(dirname "$AGENT_DIR")/agent-worktrees"
SESSION_NAME="parallel-agents"

echo "🔍 Worktree Status Report"
echo "========================"
echo ""

# Check if worktrees exist
if [ ! -d "$WORKTREES_DIR" ]; then
    echo "❌ No worktrees found. Run @worktree-init first."
    exit 1
fi

# Show worktree list
echo "📁 Active Worktrees:"
git worktree list
echo ""

# Check git status for each worktree
echo "🔄 Git Status Summary:"
for i in {1..5}; do
    worktree_dir="$WORKTREES_DIR/agent-$i"
    if [ -d "$worktree_dir" ]; then
        cd "$worktree_dir"
        status=$(git status --porcelain | wc -l | xargs)
        if [ "$status" -eq 0 ]; then
            echo "Agent $i: Clean working tree"
        else
            modified=$(git status --porcelain | grep "^ M" | wc -l | xargs)
            added=$(git status --porcelain | grep "^A " | wc -l | xargs)
            untracked=$(git status --porcelain | grep "^??" | wc -l | xargs)
            
            status_msg="Agent $i:"
            [ "$modified" -gt 0 ] && status_msg="$status_msg $modified modified"
            [ "$added" -gt 0 ] && status_msg="$status_msg $added staged"
            [ "$untracked" -gt 0 ] && status_msg="$status_msg $untracked untracked"
            echo "$status_msg files"
        fi
        cd "$AGENT_DIR"
    else
        echo "Agent $i: Worktree not found"
    fi
done
echo ""

# Check tmux sessions
echo "💻 Tmux Sessions:"
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "$SESSION_NAME: Active ($(tmux list-panes -t "$SESSION_NAME" | wc -l | xargs) panes)"
else
    echo "No active parallel agent sessions"
fi
echo ""

# Check logs
echo "📊 Recent Activity:"
log_dir="$AGENT_DIR/logs"
if [ -d "$log_dir" ]; then
    latest_run=$(ls -t "$log_dir" | head -1)
    if [ -n "$latest_run" ]; then
        echo "Latest run: $latest_run"
        for i in {1..5}; do
            log_file="$log_dir/$latest_run/agent-$i.log"
            if [ -f "$log_file" ]; then
                size=$(wc -l < "$log_file" 2>/dev/null || echo "0")
                echo "Agent $i: $size lines logged"
            else
                echo "Agent $i: No log file"
            fi
        done
    else
        echo "No previous runs found"
    fi
else
    echo "No logs directory found"
fi

echo ""
echo "✅ Status check complete!"