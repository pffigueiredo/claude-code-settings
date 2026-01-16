# PR Creation Command

Create a pull request with proper formatting and description.

## Phase 1: Discoverability

Before creating the PR, discover existing patterns and templates:

### 1. Check for GitHub PR Templates
```bash
ls -la .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null
ls -la .github/pull_request_template.md 2>/dev/null
ls -la .github/PULL_REQUEST_TEMPLATE/ 2>/dev/null
```

### 2. Search Documentation for PR Conventions
Check these files for PR/commit/contribution guidelines:
```bash
# Search for PR-related sections in documentation files
grep -il "pull request\|PR \|commit\|contribution" README.md CONTRIBUTING.md AGENTS.md CLAUDE.md .github/*.md docs/*.md 2>/dev/null
```

Then read relevant sections from any matches:
- `CLAUDE.md` / `AGENTS.md` - AI-specific instructions often include PR format (highest priority)
- `CONTRIBUTING.md` - Standard place for contribution guidelines
- `README.md` - Sometimes includes "How to contribute" sections
- `.github/*.md` - Other GitHub-specific docs

### 3. Analyze Recent PRs for Patterns
```bash
# Get recent merged PR titles to detect naming conventions
gh pr list --state merged --limit 10 --json title,number --jq '.[] | "\(.number): \(.title)"'
```

### 4. Determine Convention Priority
1. **Explicit instructions** in CLAUDE.md/AGENTS.md take highest priority
2. **PR template** if it exists
3. **CONTRIBUTING.md** guidelines
4. **Pattern from recent PRs** - detect if they use semantic, ticket-based, or plain titles
5. **Default to semantic versioning** only if nothing else found

## Phase 2: PR Creation

### Title Guidelines
- Follow the convention detected in Phase 1
- If no convention found, default to semantic versioning: `type(scope): description`
- Keep it concise and descriptive
- Single line only

### Body Guidelines
- If a PR template exists, use it and fill in the sections
- If explicit instructions exist in CLAUDE.md/AGENTS.md, follow those
- If no template exists, use the default structure below
- Summarize changes comparing current branch against base branch (usually main)

## Default Template (when no repo template exists)

```bash
gh pr create --title "{{TITLE}}" --body "$(cat <<'EOF'
## Description

This PR aims to (replace with a short description of the changes).

**FEATURES**
- [bullet point]

**FIXES**
- [bullet point]

**BREAKING CHANGES**
- [bullet point]

## Test Plan

EOF
)"
```

## Description
This command creates a GitHub pull request using the `gh` CLI tool with:
- A discoverability phase to detect existing templates and conventions
- Adaptive title formatting based on repository patterns
- A formatted body using repo template or default heredoc
- Proper multiline handling for consistent PR descriptions

If $ARGUMENTS is provided, follow the instructions in the arguments.
