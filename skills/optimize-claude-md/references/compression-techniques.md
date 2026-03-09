# Compression Techniques

Apply these when rewriting the main CLAUDE.md.

## Technique Catalog

| Technique | Example Before | Example After |
|-----------|---------------|---------------|
| Pipe-delimited tables | Multi-line tool descriptions | `name\|purpose\|when` |
| Kill restating prose | "This means you should..." | (delete) |
| Merge overlapping rules | 3 rules about same topic | 1 combined rule |
| Replace examples with refs | 15-line code block | `docs/examples/auth.md` |
| Canonical API hint + extract | 27-line usage example | 1-line hint in main + full example in `docs/` |
| Strip formatting overhead | HRs, excessive headers | Minimal headers only |
| Abbreviate language | "You should always make sure to" | "Always" |
| One rule per line | Multi-line bullets with sub-bullets | Single line, no sub-bullets |
| Extract lesson from journal | "2024-11-22: We discovered counts were wrong..." | "Always verify file counts match descriptions" |

## Content Categories

Categorize each content block into one of:

| Category | Description |
|----------|-------------|
| Core rules | Behavioral directives, always needed (< 2 lines each) |
| High-stakes warnings | Gotchas, naming collisions, "never do X" rules — always in main file regardless of frequency |
| Tooling index | Commands, agents, skills, MCP tools |
| Workflow guidance | Multi-step processes, conventions |
| Reference material | Tables, config examples, API details |
| Structured data blocks | Code, JSON schemas, YAML configs, SQL — any fenced block > 5 lines |
| Troubleshooting | Error handling, known issues, workarounds |
| Learnings/retrospectives | Dated journal entries, post-mortems, "Key Learnings" sections |

## Decision Tree

```
Is the content volatile (line numbers, variable names, IDs, counts)?
├── Yes → Remove or generalize (e.g., "User model at line 45" → "User model")
└── No → Can Claude derive this with a single tool call AND it's 3+ lines?
    ├── Yes → Omit. Derivation is cheaper than the context cost. (But if deriving requires 3+ files or interpreting non-obvious configs → keep it.)
    └── No → Is it a high-stakes warning (gotcha, naming collision, "never do X")?
        ├── Yes → Keep in CLAUDE.md (low-frequency but high-consequence, cheap to keep)
        └── No → Is it a behavioral rule (< 2 lines)?
            ├── Yes → Is it relevant to 90%+ of prompts?
            │   ├── Yes → Keep in CLAUDE.md
            │   └── No → Move to docs/ (it's task-specific, not universal)
            └── No → Is it needed in 90%+ of prompts?
                ├── Yes → Compress + keep in CLAUDE.md or move to rules/ (auto-loaded)
                └── No → Move to docs/
                    └── Add docs/filename.md reference in CLAUDE.md
```

## Placement Rules

- Behavioral rules relevant to 90%+ of prompts (< 2 lines each) → main CLAUDE.md
- Workflow/convention rules → `.claude/rules/*.md` (auto-loaded, same priority as CLAUDE.md)
- Deep reference material → `docs/*.md` (referenced via `docs/file.md` imports, loaded on-demand)
- Structured data blocks > 5 lines (code, JSON, YAML, SQL) → `docs/examples/` or `docs/schemas/`
- **Canonical API examples** (code blocks that ARE the primary documentation for how to use a project's API) → keep a 1-line compressed usage hint in CLAUDE.md (e.g., `createClient({ url, auth, options? }) → docs/api-usage.md`), extract the full example to docs/. This ensures Claude sees the API shape without loading 20+ lines of code on every prompt.
- **Learnings/retrospectives** (dated journal entries, "Key Learnings" sections) → extract the actionable lesson as a compressed rule, discard the narrative/date context. E.g., "2024-11-22: We discovered counts were wrong in 3 places" becomes "Always verify file counts match descriptions across plugin.json, marketplace.json, and README." If a learning contains no actionable rule, move to `docs/` or strip entirely.

### `.claude/rules/` vs `docs/` — Key Difference

`.claude/rules/*.md` files are **auto-loaded as passive context** (always present, like CLAUDE.md itself). Use for content that applies to every prompt: coding conventions, workflow rules, team policies.

`docs/*.md` files are **on-demand** — loaded only when Claude determines they are relevant. Use for reference material, API docs, schemas, detailed examples.

Misplacing content between these two defeats the optimization: putting rarely-needed content in rules/ wastes context; putting always-needed rules in docs/ risks them being missed.

## Anti-Patterns

- **Blind summarization.** Summarizing 18K→122 tokens drops accuracy 66.7%→57.1%. Restructure instead.
- **Deleting content.** Everything extracted must remain reachable via docs/ or rules/.
- **Compressing what is already concise.** Skip files under 30 lines.
- **Rewriting meaning.** Compress phrasing, not intent.
- **Orphan docs.** Every extracted file must be referenced from main CLAUDE.md.
- **Volatile references.** Line numbers, variable names, specific counts, file sizes — these go stale within days. Remove the volatile part or generalize (e.g., "User model at line 45" → "User model").
- **Stating the obvious (badly).** Don't include multi-line content Claude can derive with a single tool call: project directory trees (use `ls`), standard framework conventions, default tool behavior. But DO keep 1-2 line facts even if technically derivable — "tests use Vitest" (10 tokens passive) is cheaper than Claude running a tool call to discover it (~200-500 tokens + latency). The question is "is derivation cheaper than context?" not "can Claude derive it?"
- **Keeping rarely-used content in main file.** If a rule only applies to 1 in 10 tasks (e.g., "how to deploy" or "promotion workflow"), it belongs in `docs/`, not the main file — even if it's important when it IS needed.
