# PR Creation Command

Create a pull request with proper formatting and description.

Title:
- The title needs to follow semantic versioning.
- The title needs to be a single line.
- The title needs to be a short description of the changes.
- The title needs to be a single line.

## Usage
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
- A descriptive title
- A formatted body using a heredoc for proper multiline handling
- Template placeholder for consistent PR descriptions

If $ARGUMENTS is provided, follow the instructions in the arguments.