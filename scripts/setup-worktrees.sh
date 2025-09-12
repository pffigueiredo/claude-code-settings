#!/bin/bash

# Set up 5 git worktrees for parallel development with Claude agents
# Each worktree gets its own branch based on the current branch

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKTREES_DIR="$(dirname "$AGENT_DIR")/agent-worktrees"
CURRENT_BRANCH=$(git branch --show-current)

echo "Setting up 5 worktrees for parallel development..."
echo "Base branch: $CURRENT_BRANCH"
echo "Main repo: $AGENT_DIR"
echo "Worktrees dir: $WORKTREES_DIR"

# Create worktrees directory if it doesn't exist
mkdir -p "$WORKTREES_DIR"

# Function to setup a single worktree
setup_worktree() {
    local agent_num=$1
    local branch_name="experiment/agent-$agent_num"
    local worktree_dir="$WORKTREES_DIR/agent-$agent_num"
    
    echo "Setting up agent-$agent_num..."
    
    # Create branch if it doesn't exist
    echo "  Creating branch: $branch_name"
    git branch "$branch_name" "$CURRENT_BRANCH" 2>/dev/null || git checkout "$branch_name"
    git checkout "$CURRENT_BRANCH"
    
    # Remove worktree if it already exists
    if [ -d "$worktree_dir" ]; then
        echo "  Removing existing worktree: $worktree_dir"
        git worktree remove "$worktree_dir" --force 2>/dev/null || rm -rf "$worktree_dir"
    fi
    
    # Create worktree
    echo "  Creating worktree: $worktree_dir"
    git worktree add "$worktree_dir" "$branch_name"
    
    echo "  ✓ agent-$agent_num ready at $worktree_dir"
}

# Setup all 5 worktrees
for i in {1..5}; do
    setup_worktree $i
done

echo ""
echo "🎉 All worktrees created successfully!"
echo ""
echo "Worktrees:"
git worktree list
echo ""
echo "You can now run: @worktree-run \"your prompt here\""