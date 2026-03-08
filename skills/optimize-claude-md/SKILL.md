---
name: optimize-claude-md
description: Optimizes CLAUDE.md/agents.md by restructuring verbose content into docs/*.md and compressing the main file using Vercel's agents.md index pattern. Use when a project's CLAUDE.md is bloated, unstructured, or could benefit from compressed passive context.
---

# Optimize CLAUDE.md

Restructure for progressive disclosure, compress for passive context. Based on Vercel's research: passive context (always-loaded) achieves 100% pass rate vs 53-79% for on-demand retrieval. Pipe-delimited compressed index reduced 40KB → 8KB with 100% accuracy.

**Claude is the compression engine.** No external tools — analyze, categorize, and rewrite content using the techniques below.

## Core Principle

- Main file stays under 60 lines with pipe-delimited index
- Verbose/reference content moves to `docs/` or `.claude/rules/`
- Never lose information — restructure, don't delete
- Don't compress what's already concise — skip files under 30 lines

## Quick Start

Invoke on any project with a CLAUDE.md or agents.md. The skill reads, analyzes, proposes restructuring, gets confirmation, then executes.

## Workflow

### Phase 1: Discovery

Find all instruction files in the project:

**Search for:**
- `CLAUDE.md` (project root)
- `.claude/CLAUDE.md`
- `agents.md`, `AGENTS.md`
- `.claude/rules/*.md`
- `docs/*.md` (check if docs/ already exists)

**Report:**
| File | Lines | Size |
|------|-------|------|
| path | count | KB   |

Note which directories already exist (`docs/`, `.claude/rules/`).

### Phase 2: Analysis

Read every instruction file. Categorize each content block into one of:

| Category | Description |
|----------|-------------|
| Core rules | Behavioral directives, always needed (< 2 lines each) |
| Tooling index | Commands, agents, skills, MCP tools |
| Workflow guidance | Multi-step processes, conventions |
| Reference material | Tables, config examples, API details |
| Code examples | Inline code blocks > 5 lines |
| Troubleshooting | Error handling, known issues, workarounds |

**Flag:**
- Blocks > 5 lines → extraction candidates
- Duplicate/overlapping content → merge candidates
- Commands/agents/skills mentioned → index candidates

Present analysis table to user:

| Block | Category | Lines | Action |
|-------|----------|-------|--------|
| "Git rules" | Core rules | 3 | Keep |
| "API reference table" | Reference | 45 | Extract |
| "Build workflow" | Workflow | 22 | Extract |

### Phase 3: Restructuring Proposal

Present restructuring plan as a table:

| Content Block | Current Location | Proposed Location | Reason |
|---------------|------------------|-------------------|--------|
| Git rules | CLAUDE.md:12-14 | CLAUDE.md (keep) | Core rule, 3 lines |
| API reference | CLAUDE.md:30-75 | docs/api-reference.md | Reference, 45 lines |
| Build workflow | CLAUDE.md:80-102 | .claude/rules/build.md | Auto-loaded workflow |

**For tooling indexes, propose pipe-delimited format:**

```
## Commands
name|purpose|when-to-use
/deploy|deploy to prod|after PR merge
/test|run test suite|before commits
```

**Show before/after line count estimate.**

**Decision criteria:**

```
Is content a behavioral rule (< 2 lines)?
├── Yes → Keep in CLAUDE.md
└── No → Is it needed every prompt?
    ├── Yes → Compress + keep in CLAUDE.md or move to rules/ (auto-loaded)
    └── No → Move to docs/
        └── Add @docs/filename.md reference
```

- Always-needed behavioral rules (< 2 lines each) → stays in main file
- Workflow/convention rules → `.claude/rules/*.md` (auto-loaded, same priority as CLAUDE.md)
- Deep reference material → `docs/*.md` (referenced via `@docs/file.md` imports)
- Code examples > 5 lines → `docs/examples/`

### Phase 4: Confirmation

**Present full preview of proposed new CLAUDE.md to user.**

List all files to create:
```
CREATE: docs/api-reference.md (45 lines extracted)
CREATE: .claude/rules/build.md (22 lines extracted)
REWRITE: CLAUDE.md (120 lines → 48 lines)
```

Ask user to approve, modify, or reject each proposed change. Do NOT proceed without explicit approval.

### Phase 5: Execution

Apply approved changes:

1. Create `docs/` and/or `.claude/rules/` directories as needed
2. Write extracted content to new files (preserve full detail)
3. Rewrite CLAUDE.md using compression techniques (below)
4. Add `docs/filename.md` import references for extracted content
5. Report before/after metrics:

```
BEFORE: CLAUDE.md = 120 lines
AFTER:  CLAUDE.md = 48 lines
        docs/api-reference.md = 45 lines
        .claude/rules/build.md = 22 lines
Total information: preserved (0 lines lost)
```

## Compression Techniques

Apply these when rewriting the main CLAUDE.md:

| Technique | Example Before | Example After |
|-----------|---------------|---------------|
| Pipe-delimited tables | Multi-line tool descriptions | `name\|purpose\|when` |
| Kill restating prose | "This means you should..." | (delete) |
| Merge overlapping rules | 3 rules about same topic | 1 combined rule |
| Replace examples with refs | 15-line code block | `@docs/examples/auth.md` |
| Strip formatting overhead | HRs, excessive headers | Minimal headers only |
| Abbreviate language | "You should always make sure to" | "Always" |
| One rule per line | Multi-line bullets with sub-bullets | Single line, no sub-bullets |

**Critical: preserve user's voice/intent in rules.** Compress form, not meaning.

## Anti-Patterns

- **Don't blindly summarize.** Summarizing 18K→122 tokens drops accuracy 66.7%→57.1%. Restructure instead.
- **Don't delete content.** Everything extracted must remain reachable via docs/ or rules/.
- **Don't compress what's already concise.** Skip files under 30 lines.
- **Don't rewrite meaning.** Compress phrasing, not intent.
- **Don't create orphan docs.** Every extracted file must be referenced from main CLAUDE.md.
- **NEVER use @docs/filename.md imports.** Use docs/filename.md instead, using '@' would load the file into context every time the file is referenced.

## Guidelines

- Target: main CLAUDE.md under 60 lines
- Never lose information — everything extracted must be reachable
- Prefer `rules/` over `docs/` for content that should auto-load every session
- Prefer `docs/` for reference material only needed occasionally
- Preserve user's voice/intent in rules (don't rewrite meaning)
- Always show before/after metrics
- Always get explicit confirmation before writing any files
