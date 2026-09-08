# Update Documentation

Intelligently update all project documentation to ensure accuracy and completeness. This command prioritizes outcomes over time windows - if documentation is inaccurate or outdated, fix it regardless of when the mismatch occurred. Follow these steps:

1. **Identify Documentation Files**
   - Look for CLAUDE.md or claude.md in `$CLAUDE_PROJECT_DIR`
   - Find README.md files at project root and key subdirectories
   - Find other relevant .md files in docs/ directories
   - Check for architectural decision records (ADRs) if present

2. **Analyze Recent Changes and Current State**
   - Use `git log --since="<CLAUDE.md-last-modified-date>" --name-only --pretty=format:"%H %s"` to get recent changes
   - For key files, get diffs: `git diff <commit-before-CLAUDE.md-update> HEAD -- <file>`
   - Focus on tracked directories (agents/, commands/, scripts/, src/, etc.)
   - **Critically: Also check if documentation accurately reflects the current codebase state**
   - Review conversation history for architectural decisions and context not visible in diffs

3. **Identify Documentation Gaps and Inaccuracies**
   - **Compare current codebase reality with what documentation claims**
   - Check if README accurately describes:
     - Current tech stack and architecture
     - Project structure and organization
     - Setup and installation steps
     - Usage instructions
   - Check if CLAUDE.md accurately describes:
     - Key patterns and conventions
     - Project structure and file organization
     - Important context for future sessions
   - Identify outdated information, missing sections, or misleading descriptions

4. **Update CLAUDE.md** (if it exists)
   - Add new architectural patterns or components introduced
   - Document new dependencies or integrations added
   - Update file structure section if significant changes were made
   - Add any important decisions or context for future sessions
   - Include links to relevant files or sections of code
   - **Correct any inaccuracies found, even if they predate recent commits**
   - Keep existing content, only add or update relevant sections

5. **Update README.md and Other Documentation**
   - **Fix any mismatches between documentation and current codebase state**
   - Update tech stack description if it changed (e.g., Python → TypeScript)
   - Update architecture description if project was restructured (e.g., monorepo migration)
   - Update setup instructions if dependencies or process changed
   - Update technical docs in docs/ if APIs, schemas, or interfaces changed
   - Update ADRs if present and relevant

6. **Provide Update Summary**
   - List all files that changed since last CLAUDE.md update
   - **List all documentation inaccuracies found and fixed**
   - Summarize what documentation was updated and why
   - Note any important context captured for future reference
   - If no updates were needed, state that clearly

**Guidelines:**
- **Prioritize accuracy over time windows** - fix outdated documentation even if the issue is old
- **Check if documentation reflects current reality**, not just recent changes
- Be thorough in checking README against actual tech stack and architecture
- Be concise but comprehensive
- Preserve existing documentation structure and style
- Focus on information that will be useful for future development
- Use both code diffs and conversation context to inform updates
- If CLAUDE.md doesn't exist, use first commit as reference point
- Common sense over rigid rules - if documentation is wrong, fix it

If $ARGUMENTS is provided, focus documentation updates on those specific areas or topics.

