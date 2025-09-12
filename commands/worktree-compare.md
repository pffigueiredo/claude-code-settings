# Worktree Compare Command

Compare results and approaches across all 5 agent worktrees.

Generates detailed analysis reports showing how each agent approached the same problem differently.

## Usage

```bash
cd /Users/pedro.figueiredo/Documents/git/neon/agent
./scripts/compare-results.sh
```

## Description

This command analyzes each worktree and generates:

### Individual Agent Reports
- **Git status** and changed files
- **Commit history** with messages
- **Detailed diffs** of all changes
- **File tree** of new/modified files

### Summary Report
- **Overview** of changes per agent
- **Common patterns** across agents
- **Unique approaches** taken by each
- **Recommendations** for next steps

## Output Structure

```
reports/comparison-YYYYMMDD-HHMMSS/
├── summary-report.txt           # Main comparison summary
├── agent-1-analysis.txt         # Detailed analysis for agent 1
├── agent-2-analysis.txt         # Detailed analysis for agent 2
├── agent-3-analysis.txt         # Detailed analysis for agent 3
├── agent-4-analysis.txt         # Detailed analysis for agent 4
└── agent-5-analysis.txt         # Detailed analysis for agent 5
```

## What It Analyzes

- **Code changes** - Files modified by each agent
- **Implementation patterns** - Common approaches vs unique solutions
- **Commit strategies** - How each agent organized their work
- **File organization** - Where each agent placed new code
- **Problem-solving approaches** - Different ways to tackle the same task

## Example Output

The summary report might show:
```
Agent 1: 5 changed files, 3 commits - REST API with Express
Agent 2: 8 changed files, 1 commit - GraphQL implementation  
Agent 3: 3 changed files, 5 commits - Minimal FastAPI solution
Agent 4: 12 changed files, 2 commits - Full-stack with React
Agent 5: 4 changed files, 4 commits - Microservices architecture
```

## Prerequisites

Run after `@worktree-run` has been executed and agents have made changes.