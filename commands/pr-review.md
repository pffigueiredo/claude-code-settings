# Multi-Perspective PR Review

Review the current branch changes against main using 5 different expert personalities in parallel. Follow these steps:

1. **Get the branch diff**: Run `git diff main...HEAD` to analyze all changes
2. **Multi-personality analysis**: Review the diff through 5 expert lenses.
3. **Actionable Recommendations**: Give specific, implementable suggestions for each major issue found, keep it short and concise, use colors to highlight the most important issues, also, present the files and lines of code that are affected by the issue.

If $ARGUMENTS is provided, focus the review on those specific areas or files.