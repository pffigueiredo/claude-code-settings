---
name: optimize-claude-md
description: Optimizes existing CLAUDE.md/agents.md by restructuring verbose content into docs/*.md and compressing the main file using Vercel's agents.md index pattern. This skill should be used when a project's CLAUDE.md is bloated, unstructured, exceeds 60 lines, or could benefit from compressed passive context. Triggers on "optimize", "clean up", "compress", "slim down", "restructure", "too long", or "bloated" mentions regarding CLAUDE.md or agents.md files. Do NOT trigger when the user wants to create, write, or generate a new CLAUDE.md from scratch, or when asking questions about what CLAUDE.md is or what it should contain.
---

# Optimize CLAUDE.md

Restructure for progressive disclosure, compress for passive context. Primary goal: reduce noise so Claude focuses on the rules that matter — correct file paths, testing requirements, naming collisions, architectural patterns. Vercel's research confirms passive context (always-loaded) achieves 100% pass rate vs 53-79% for on-demand retrieval.

**Claude is the compression engine.** No external tools — analyze, categorize, and rewrite content using techniques in `references/compression-techniques.md`.

## Core Principles

- Target under 60 lines in main file with pipe-delimited index. When core behavioral rules exceed this after compression, prioritize keeping rules over hitting the target — accuracy > brevity
- Verbose/reference content moves to `docs/` or `.claude/rules/`
- Never lose instructions or decisions — restructure, don't delete. (Facts Claude can derive from the codebase don't count — those can be omitted)
- Skip files already under 30 lines — unless they reference 6+ docs/ files (consolidation may still help; see docs/ cap rule in Phase 3)
- Files 60-100 lines that are already well-structured → lighter touch. Only extract clear reference material (schemas, code blocks, tree diagrams). Do not force compression of already-concise workflow guidance

## What Good Looks Like

The best optimized CLAUDE.md files share these traits:
- **Correct paths are explicit.** In monorepos, exact import paths and file locations prevent agents from guessing wrong. "Export from `packages/react/src/hooks/`" beats "export from the React package"
- **Testing rules are prominent.** When testing requirements are visible in the main file, agents write tests consistently. When buried in docs/, they skip them
- **Gotchas are inline.** Naming collisions, race conditions, and "never do X" warnings work only when visible on every prompt — not when agents have to discover them via docs/
- **Commands are discoverable.** The pipe-delimited command index ensures agents find commands without reading workflow docs

## Workflow

### Phase 1: Discovery

Find all instruction files in the project:

- `CLAUDE.md` (project root and subdirectories)
- `.claude/CLAUDE.md`
- `agents.md`, `AGENTS.md`
- `.claude/rules/*.md`
- `.cursorrules`, `.github/copilot-instructions.md`
- `docs/*.md` (check if docs/ already exists with non-instruction content)

Report as table: File | Lines | Size (KB). Note which directories already exist.

When `docs/` already contains non-instruction content, use `docs/claude/` for extracted files.

**Edge cases:**
- No CLAUDE.md exists → nothing to optimize, exit early
- Monorepo with subdirectory CLAUDE.md files → optimize each independently, do not consolidate (subdirectory files scope to their directory)
- Conflicting instructions across files → flag conflicts in the analysis table, ask user to resolve before proceeding
- Non-markdown files (`.cursorrules`, `copilot-instructions.md`) → convert to `.claude/rules/*.md` format or leave alone per user preference
- Previously optimized CLAUDE.md with existing `docs/` structure → do incremental extraction, preserve existing docs, only extract newly-added content

### Phase 2: Analysis

Read every instruction file. Categorize each content block using the categories in `references/compression-techniques.md`.

Flag: blocks > 5 lines (extraction candidates), duplicate content (merge candidates), commands/agents/skills (index candidates).

Apply three filters to each block before deciding placement:
1. **Frequency test** — Will this be relevant to 90%+ of prompts? If not → `docs/`, even if it's a behavioral rule. Exception: if the compressed rule is 1 line and high-stakes (see below), keep it. The 90% threshold is a guideline, not a hard cutoff — when in doubt about a 1-line rule, keep it; the context cost is ~10 tokens
2. **Volatility test** — Does it reference things that change often (line numbers, variable names, specific counts, IDs)? If yes → remove or generalize. Stale instructions are worse than no instructions
3. **Derivability test** — Can Claude figure this out with a single tool call (`ls`, reading 1 file)? If yes AND the instruction is 3+ lines → omit. If it's a 1-2 line fact, keep it — a 10-token instruction in passive context is almost always cheaper than a tool call (~200-500 tokens + latency). The question isn't "can Claude derive it?" but "is deriving it cheaper than keeping it?" Examples of what to omit: project directory tree (derivable via `ls`, 10+ lines). Examples of what to keep: "tests use Vitest, not Jest" (1 line, saves a tool call every session)

Distinguish between **always-needed behavioral rules** (keep in main file) and **task-specific procedures** (extract to docs/). A procedure triggered only by specific tasks ("User wants to promote a plugin") belongs in docs/, not the main file — even if it tells Claude what to do.

**Exception — high-stakes rules:** Gotchas, naming collisions, critical warnings, and "never do X" rules stay in the main file even if they fail the frequency test. These are low-frequency but high-consequence: missing them causes bugs that are hard to diagnose. Examples: "never name a plugin `analytics` — collides with existing", "always cancel stale fetches in useEffect cleanup". Cost of keeping a 1-line warning is negligible; cost of missing it is a broken implementation.

Strip non-instructional metadata (last-updated dates, repository URLs, maintainer links) unless they contain actionable information Claude needs.

Present analysis table: Block | Category | Lines | Action (Keep/Extract/Merge).

### Phase 3: Restructuring Proposal

Present restructuring plan as table: Content Block | Current Location | Proposed Location | Reason.

For tooling indexes, propose pipe-delimited format:
```
## Commands
name|purpose|when-to-use
/deploy|deploy to prod|after PR merge
```

Apply the decision tree from `references/compression-techniques.md` for placement. Show before/after line count estimate.

Include a **draft preview** of the compressed CLAUDE.md alongside the table — evaluating a table of moves is hard, seeing the actual output is easy.

**IMPORTANT:** Reference extracted docs as `docs/filename.md` (no `@` prefix). The `@` prefix loads files into context on every reference, defeating the purpose of extraction.

**IMPORTANT:** When extracting a workflow to docs/, any commands mentioned in that workflow must still appear in the main commands pipe-delimited index. The commands table is a discoverability index — commands should be findable there even if their surrounding workflow context lives in docs/. Example: extracting a "Releasing" workflow to `docs/claude/releasing.md` still means `pnpm release` appears in the commands table.

**IMPORTANT:** Cap extracted docs/ at 5 files maximum. If you have more, consolidate related content into fewer files (e.g., `docs/api-and-database.md` instead of separate `docs/api-reference.md` + `docs/database.md`). Each docs/ file is a discovery cost — the agent must decide whether to read it and spend tokens doing so.

### Phase 4: Confirmation

Present full preview of proposed new CLAUDE.md. List all files to create:
```
CREATE: docs/api-reference.md (45 lines extracted)
CREATE: .claude/rules/build.md (22 lines extracted)
REWRITE: CLAUDE.md (120 lines -> 48 lines)
```

Get explicit approval before writing any files. Do NOT proceed without it.

### Phase 5: Execution

Apply approved changes:

1. Create `docs/` and/or `.claude/rules/` directories as needed
2. Write extracted content to new files (preserve full detail)
3. Rewrite CLAUDE.md using techniques from `references/compression-techniques.md`
4. Add `docs/filename.md` import references for extracted content
5. Report before/after metrics: line counts, file counts, "0 lines lost"

For a complete before/after example, read `references/example-before-after.md`.

### Phase 6: Validation

Verify the optimization preserved all meaning:

1. Re-read compressed CLAUDE.md and every extracted doc
2. Confirm every original instruction is reachable (in main file, rules/, or docs/)
3. Spot-check compressed rules for meaning drift — e.g., "prefer interfaces over types for object shapes" compressed to "interfaces over types" loses the "for object shapes" qualifier
4. Run `scripts/validate-references.sh <path-to-CLAUDE.md>` to verify all `docs/` references point to existing files
5. Report: total instructions before vs after, any meaning changes flagged
6. Note to user: early data suggests less noise may produce more predictable behavior across repeated runs — worth observing but not yet proven at scale
