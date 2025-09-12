# Worktree Compare Command

Analyzes and compares the different approaches taken by each agent across all 5 worktrees.

## Usage

```bash
cd /Users/pedro.figueiredo/Documents/git/neon/agent && ./scripts/worktree-compare.sh
```

## Description

This command performs intelligent comparison across all agent implementations:

1. **File Differences**: Shows which files were modified/created by each agent
2. **Code Analysis**: Highlights different approaches to the same problem
3. **Performance Metrics**: Compares lines of code, complexity, patterns used
4. **Best Practices**: Identifies which agents followed better coding practices
5. **Merge Recommendations**: Suggests which changes to combine for optimal solution

## Comparison Categories

- **Architecture Decisions**: Framework choices, component structure
- **Implementation Patterns**: Different ways of solving the same problem  
- **Code Quality**: TypeScript usage, error handling, testing
- **Performance**: Bundle size impact, runtime efficiency
- **User Experience**: UI/UX differences, accessibility

## Sample Output

```
🔀 Agent Comparison Report
=========================

📊 Implementation Summary:
Agent 1: Used hooks-based approach, 3 new components
Agent 2: Class components, more defensive error handling
Agent 3: Custom hooks + Context API, best TypeScript coverage
Agent 4: Minimal changes, focused on performance
Agent 5: Most comprehensive, added testing

🏆 Best Practices Winners:
- TypeScript: Agent 3 (100% coverage)
- Performance: Agent 4 (smallest bundle impact) 
- Testing: Agent 5 (full test suite)
- Code Style: Agent 1 (most readable)

💡 Merge Recommendations:
- Take TypeScript interfaces from Agent 3
- Use performance optimizations from Agent 4
- Adopt testing strategy from Agent 5
- Keep component structure from Agent 1
```

## Prerequisites

- Agents must have completed their work
- Run `@worktree-status` first to ensure all agents are finished