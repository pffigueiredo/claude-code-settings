#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Get current working directory from input
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get current directory name (like %c in zsh)
current_dir=$(basename "$cwd")

# Get model information
model_display_name=$(echo "$input" | jq -r '.model.display_name')

# Get transcript path and calculate token usage
transcript_path=$(echo "$input" | jq -r '.transcript_path')
token_info=""
if [ -f "$transcript_path" ]; then
    # Count approximate tokens by word count (rough estimate: 1 token ≈ 0.75 words)
    word_count=$(wc -w < "$transcript_path" 2>/dev/null || echo "0")
    approx_tokens=$((word_count * 4 / 3))
    if [ "$approx_tokens" -gt 1000 ]; then
        token_info="~$((approx_tokens / 1000))k tokens"
    else
        token_info="~${approx_tokens} tokens"
    fi
fi

# Check if we're in a git repository and get status
git_info=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    # Get current branch name
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Check if there are uncommitted changes
        if git -C "$cwd" diff --quiet 2>/dev/null && git -C "$cwd" diff --cached --quiet 2>/dev/null; then
            # Clean repository
            git_info="git:($branch)"
        else
            # Dirty repository
            git_info="git:($branch) ✗"
        fi
    fi
fi

# Create the status line with model, tokens, directory, and git info
# Colors: green arrow, cyan directory, blue git info, magenta model, yellow tokens
# Removed dim (\033[2m) for better visibility, added separators for better organization
printf "\033[1;32m➜\033[0m \033[36m%s\033[0m" "$current_dir"

if [ -n "$git_info" ]; then
    printf " \033[90m|\033[0m \033[1;34m%s\033[0m" "$git_info"
fi

printf " \033[90m|\033[0m \033[35m%s\033[0m" "$model_display_name"

if [ -n "$token_info" ]; then
    printf " \033[90m|\033[0m \033[33m%s\033[0m" "$token_info"
fi