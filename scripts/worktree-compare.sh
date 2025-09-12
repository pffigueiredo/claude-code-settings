#!/bin/bash

# Compare approaches taken by different agents across worktrees

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKTREES_DIR="$(dirname "$AGENT_DIR")/agent-worktrees"
MAIN_BRANCH=$(git branch --show-current)

echo "🔀 Agent Comparison Report"
echo "========================="
echo ""

# Check if worktrees exist
if [ ! -d "$WORKTREES_DIR" ]; then
    echo "❌ No worktrees found. Run @worktree-init first."
    exit 1
fi

echo "📊 Implementation Summary:"
echo ""

# Function to analyze a single agent
analyze_agent() {
    local agent_num=$1
    local worktree_dir="$WORKTREES_DIR/agent-$agent_num"
    
    if [ ! -d "$worktree_dir" ]; then
        echo "Agent $agent_num: Worktree not found"
        return
    fi
    
    cd "$worktree_dir"
    
    # Count changes
    local files_changed=$(git diff --name-only HEAD~1 2>/dev/null | wc -l | xargs)
    local lines_added=$(git diff --shortstat HEAD~1 2>/dev/null | sed -n 's/.* \([0-9]*\) insertion.*/\1/p' || echo "0")
    local lines_removed=$(git diff --shortstat HEAD~1 2>/dev/null | sed -n 's/.* \([0-9]*\) deletion.*/\1/p' || echo "0")
    
    # Check for specific patterns
    local typescript_files=$(find . -name "*.ts" -o -name "*.tsx" | grep -v node_modules | wc -l | xargs)
    local test_files=$(find . -name "*.test.*" -o -name "*.spec.*" | grep -v node_modules | wc -l | xargs)
    local component_files=$(find . -path "*/components/*" -name "*.tsx" | wc -l | xargs)
    
    echo "Agent $agent_num:"
    echo "  📁 Files changed: $files_changed"
    echo "  ➕ Lines added: $lines_added"
    echo "  ➖ Lines removed: $lines_removed"
    echo "  🟦 TypeScript files: $typescript_files"
    echo "  🧪 Test files: $test_files"
    echo "  🧩 Components: $component_files"
    
    # Check for specific technologies/patterns
    local uses_hooks=$(grep -r "useState\|useEffect\|useGetList" . --include="*.tsx" --include="*.ts" | wc -l | xargs)
    local uses_recharts=$(grep -r "recharts\|ResponsiveContainer" . --include="*.tsx" --include="*.ts" | wc -l | xargs)
    
    [ "$uses_hooks" -gt 0 ] && echo "  🪝 Uses React hooks: $uses_hooks instances"
    [ "$uses_recharts" -gt 0 ] && echo "  📈 Uses Recharts: $uses_recharts instances"
    
    echo ""
}

# Analyze all agents
for i in {1..5}; do
    analyze_agent $i
done

cd "$AGENT_DIR"

echo "🏆 Best Practices Analysis:"
echo ""

# Find which agent made the most commits
echo "Most Active:"
most_commits=0
most_active_agent=""
for i in {1..5}; do
    if [ -d "$WORKTREES_DIR/agent-$i" ]; then
        cd "$WORKTREES_DIR/agent-$i"
        commits=$(git rev-list --count HEAD ^$(git merge-base HEAD $MAIN_BRANCH) 2>/dev/null || echo "0")
        if [ "$commits" -gt "$most_commits" ]; then
            most_commits=$commits
            most_active_agent="Agent $i"
        fi
        cd "$AGENT_DIR"
    fi
done
[ -n "$most_active_agent" ] && echo "  $most_active_agent ($most_commits commits)"

# Find largest implementation
echo ""
echo "Largest Implementation:"
most_lines=0
largest_agent=""
for i in {1..5}; do
    if [ -d "$WORKTREES_DIR/agent-$i" ]; then
        cd "$WORKTREES_DIR/agent-$i"
        lines=$(git diff --shortstat HEAD~1 2>/dev/null | sed -n 's/.* \([0-9]*\) insertion.*/\1/p' || echo "0")
        if [ "$lines" -gt "$most_lines" ]; then
            most_lines=$lines
            largest_agent="Agent $i"
        fi
        cd "$AGENT_DIR"
    fi
done
[ -n "$largest_agent" ] && echo "  $largest_agent ($most_lines lines added)"

echo ""
echo "💡 Merge Recommendations:"
echo ""
echo "  1. Review each agent's approach in detail"
echo "  2. Compare TypeScript coverage and type safety"
echo "  3. Evaluate error handling and edge cases"
echo "  4. Test performance impact of different implementations"
echo "  5. Consider combining best features from multiple agents"
echo ""

# Show file differences summary
echo "📋 Files Modified by Each Agent:"
for i in {1..5}; do
    if [ -d "$WORKTREES_DIR/agent-$i" ]; then
        cd "$WORKTREES_DIR/agent-$i"
        echo "Agent $i:"
        git diff --name-only HEAD~1 2>/dev/null | sed 's/^/  - /' || echo "  No changes"
        cd "$AGENT_DIR"
    fi
done

echo ""
echo "✅ Comparison complete! Review the analysis above to make informed decisions."