#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Get git branch (skip optional locks for performance)
if git -c gc.autodetach=false rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -c gc.autodetach=false symbolic-ref --short HEAD 2>/dev/null || git -c gc.autodetach=false rev-parse --short HEAD 2>/dev/null)
else
  branch=""
fi

# Build status line
status=""

# Add model
if [ -n "$model" ]; then
  status="${status}${model}"
fi

# Add git branch
if [ -n "$branch" ]; then
  [ -n "$status" ] && status="${status} | "
  status="${status}${branch}"
fi

# Add token usage bar
if [ -n "$used_pct" ]; then
  [ -n "$status" ] && status="${status} | "

  # Round to integer
  used_int=$(printf "%.0f" "$used_pct")

  # Create a 20-character bar
  bar_length=20
  filled=$(( (used_int * bar_length) / 100 ))
  empty=$(( bar_length - filled ))

  bar="["
  for ((i=0; i<filled; i++)); do bar="${bar}█"; done
  for ((i=0; i<empty; i++)); do bar="${bar}░"; done
  bar="${bar}]"

  status="${status}${bar} ${used_int}%"
fi

# Add directory
if [ -n "$cwd" ]; then
  [ -n "$status" ] && status="${status} | "
  status="${status}${cwd}"
fi

printf "%s" "$status"
