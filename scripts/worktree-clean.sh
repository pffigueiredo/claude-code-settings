#!/bin/bash

# Clean up all worktrees, branches, and parallel agent resources

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKTREES_DIR="$(dirname "$AGENT_DIR")/agent-worktrees"
SESSION_NAME="parallel-agents"
ARCHIVE_DIR="$AGENT_DIR/archives"

# Parse command line options
FORCE=false
KEEP_BRANCHES=false
ARCHIVE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE=true
            shift
            ;;
        --keep-branches)
            KEEP_BRANCHES=true
            shift
            ;;
        --archive)
            ARCHIVE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--force] [--keep-branches] [--archive]"
            exit 1
            ;;
    esac
done

echo "🧹 Worktree Cleanup"
echo "=================="
echo ""

# Check what resources exist
worktree_count=0
branch_count=0
tmux_active=false
log_dirs=0

if [ -d "$WORKTREES_DIR" ]; then
    worktree_count=$(find "$WORKTREES_DIR" -maxdepth 1 -type d -name "agent-*" | wc -l | xargs)
fi

if git branch | grep -q "experiment/agent-"; then
    branch_count=$(git branch | grep "experiment/agent-" | wc -l | xargs)
fi

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux_active=true
fi

if [ -d "$AGENT_DIR/logs" ]; then
    log_dirs=$(find "$AGENT_DIR/logs" -maxdepth 1 -type d -name "parallel-run-*" | wc -l | xargs)
fi

# Show what will be cleaned
echo "Found the following resources:"
[ "$worktree_count" -gt 0 ] && echo "✓ $worktree_count active worktrees"
[ "$branch_count" -gt 0 ] && echo "✓ $branch_count experiment branches"
$tmux_active && echo "✓ 1 active tmux session ($SESSION_NAME)"
[ "$log_dirs" -gt 0 ] && echo "✓ $log_dirs log directories"

if [ "$worktree_count" -eq 0 ] && [ "$branch_count" -eq 0 ] && [ "$tmux_active" = false ] && [ "$log_dirs" -eq 0 ]; then
    echo "🎉 Nothing to clean up - environment is already clean!"
    exit 0
fi

echo ""

# Archive if requested
if [ "$ARCHIVE" = true ]; then
    timestamp=$(date +%Y%m%d-%H%M%S)
    archive_path="$ARCHIVE_DIR/cleanup-$timestamp"
    mkdir -p "$archive_path"
    
    echo "🗄️  Archiving to: $archive_path"
    
    # Archive logs
    if [ -d "$AGENT_DIR/logs" ] && [ "$log_dirs" -gt 0 ]; then
        cp -r "$AGENT_DIR/logs" "$archive_path/"
    fi
    
    # Archive diffs from each worktree
    if [ "$worktree_count" -gt 0 ]; then
        mkdir -p "$archive_path/diffs"
        for i in {1..5}; do
            worktree_dir="$WORKTREES_DIR/agent-$i"
            if [ -d "$worktree_dir" ]; then
                cd "$worktree_dir"
                git diff HEAD~1 > "$archive_path/diffs/agent-$i.diff" 2>/dev/null || true
                cd "$AGENT_DIR"
            fi
        done
    fi
    
    echo "✅ Archive created"
    echo ""
fi

# Confirm unless force mode
if [ "$FORCE" = false ]; then
    echo "⚠️  This will permanently delete:"
    [ "$worktree_count" -gt 0 ] && echo "- $WORKTREES_DIR/agent-* ($worktree_count directories)"
    [ "$branch_count" -gt 0 ] && [ "$KEEP_BRANCHES" = false ] && echo "- experiment/agent-* branches ($branch_count branches)"
    $tmux_active && echo "- tmux session: $SESSION_NAME"
    
    echo ""
    read -p "Continue? [y/N]: " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Cleanup cancelled"
        exit 1
    fi
fi

echo ""
echo "🧽 Starting cleanup..."

# Kill tmux session
if $tmux_active; then
    echo "  Killing tmux session..."
    tmux kill-session -t "$SESSION_NAME"
fi

# Remove worktrees
if [ "$worktree_count" -gt 0 ]; then
    echo "  Removing worktrees..."
    for i in {1..5}; do
        worktree_dir="$WORKTREES_DIR/agent-$i"
        if [ -d "$worktree_dir" ]; then
            git worktree remove "$worktree_dir" --force 2>/dev/null || rm -rf "$worktree_dir"
        fi
    done
    
    # Remove worktrees directory if empty
    if [ -d "$WORKTREES_DIR" ]; then
        rmdir "$WORKTREES_DIR" 2>/dev/null || true
    fi
fi

# Remove branches
if [ "$branch_count" -gt 0 ] && [ "$KEEP_BRANCHES" = false ]; then
    echo "  Removing experiment branches..."
    git branch | grep "experiment/agent-" | xargs -r git branch -D
fi

# Archive old logs
if [ "$log_dirs" -gt 0 ] && [ "$ARCHIVE" = false ]; then
    echo "  Archiving logs..."
    timestamp=$(date +%Y%m%d-%H%M%S)
    mkdir -p "$ARCHIVE_DIR/logs-$timestamp"
    mv "$AGENT_DIR/logs"/* "$ARCHIVE_DIR/logs-$timestamp/" 2>/dev/null || true
fi

echo ""
echo "✅ Cleanup completed successfully!"
echo ""

# Show final state
remaining_worktrees=0
remaining_branches=0

if [ -d "$WORKTREES_DIR" ]; then
    remaining_worktrees=$(find "$WORKTREES_DIR" -maxdepth 1 -type d -name "agent-*" | wc -l | xargs)
fi

if git branch | grep -q "experiment/agent-"; then
    remaining_branches=$(git branch | grep "experiment/agent-" | wc -l | xargs)
fi

if [ "$remaining_worktrees" -eq 0 ] && [ "$remaining_branches" -eq 0 ]; then
    echo "🎉 Environment is now clean and ready for the next experiment!"
else
    echo "ℹ️  Remaining resources:"
    [ "$remaining_worktrees" -gt 0 ] && echo "  - $remaining_worktrees worktrees"
    [ "$remaining_branches" -gt 0 ] && echo "  - $remaining_branches branches"
fi

if [ "$ARCHIVE" = true ] || [ "$log_dirs" -gt 0 ]; then
    echo ""
    echo "📁 Archives are available in: $ARCHIVE_DIR"
fi