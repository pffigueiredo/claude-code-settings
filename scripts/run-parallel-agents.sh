#!/bin/bash

# Run the same prompt on 5 Claude agents in parallel using tmux
# Each agent works in its own worktree for isolated development

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKTREES_DIR="$(dirname "$AGENT_DIR")/agent-worktrees"
SESSION_NAME="parallel-agents"
LOG_DIR="$AGENT_DIR/logs/parallel-run-$(date +%Y%m%d-%H%M%S)"

# Check if prompt was provided
if [ -z "$1" ]; then
    echo "❌ Error: Please provide a prompt"
    echo "Usage: $0 \"your prompt here\""
    exit 1
fi

PROMPT="$1"

echo "🚀 Starting 5 parallel Claude agents..."
echo "Prompt: $PROMPT"
echo "Session: $SESSION_NAME"
echo "Logs: $LOG_DIR"

# Create log directory
mkdir -p "$LOG_DIR"

# Check if worktrees exist
if [ ! -d "$WORKTREES_DIR" ]; then
    echo "❌ Error: Worktrees not found. Run @worktree-init first."
    exit 1
fi

# Kill existing session if it exists
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

# Create new tmux session with 5 panes
echo "Creating tmux session with 5 panes..."

# Create session with first pane
tmux new-session -d -s "$SESSION_NAME" -c "$WORKTREES_DIR/agent-1"

# Split into 5 panes
tmux split-window -h -t "$SESSION_NAME" -c "$WORKTREES_DIR/agent-2"
tmux split-window -v -t "$SESSION_NAME:0.0" -c "$WORKTREES_DIR/agent-3"
tmux split-window -v -t "$SESSION_NAME:0.1" -c "$WORKTREES_DIR/agent-4"
tmux split-window -v -t "$SESSION_NAME:0.3" -c "$WORKTREES_DIR/agent-5"

# Balance the panes
tmux select-layout -t "$SESSION_NAME" tiled

# Function to setup a single agent pane
setup_agent_pane() {
    local agent_num=$1
    local pane_id=$((agent_num - 1))
    local worktree_dir="$WORKTREES_DIR/agent-$agent_num"
    local log_file="$LOG_DIR/agent-$agent_num.log"
    
    echo "Setting up agent-$agent_num in pane $pane_id..."
    
    # Send commands to the pane
    tmux send-keys -t "$SESSION_NAME:0.$pane_id" "echo '🤖 Agent $agent_num starting...'" Enter
    tmux send-keys -t "$SESSION_NAME:0.$pane_id" "echo 'Working directory: $(pwd)'" Enter
    tmux send-keys -t "$SESSION_NAME:0.$pane_id" "echo 'Prompt: $PROMPT'" Enter
    tmux send-keys -t "$SESSION_NAME:0.$pane_id" "echo '---'" Enter
    
    # Start Claude with the prompt and log output
    tmux send-keys -t "$SESSION_NAME:0.$pane_id" "echo '🚀 Starting Claude Agent $agent_num...'" Enter
    tmux send-keys -t "$SESSION_NAME:0.$pane_id" "echo 'Logging to: $log_file'" Enter
    tmux send-keys -t "$SESSION_NAME:0.$pane_id" "claude -p \"$PROMPT\" 2>&1 | tee \"$log_file\"" Enter
}

# Setup all 5 agent panes
for i in {1..5}; do
    setup_agent_pane $i
done

# Set pane titles
for i in {1..5}; do
    pane_id=$((i - 1))
    tmux select-pane -t "$SESSION_NAME:0.$pane_id" -T "Agent $i"
done

echo ""
echo "🎉 Tmux session '$SESSION_NAME' created with 5 agents!"
echo ""
echo "Commands:"
echo "  tmux attach -t $SESSION_NAME    # Attach to the session"
echo "  tmux kill-session -t $SESSION_NAME  # Kill the session"
echo ""
echo "Each pane is ready to run the prompt:"
echo "  \"$PROMPT\""
echo ""
echo "Logs will be saved to: $LOG_DIR"

# Auto-attach to the session
echo "Auto-attaching to tmux session..."
tmux attach -t "$SESSION_NAME"