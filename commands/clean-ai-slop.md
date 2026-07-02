# Remove AI code slop

Check the diff against main, and remove all AI generated slop introduced in this branch.

This includes:
- Extra comments that a human wouldn't add or is inconsistent with the rest of the file
- Comments longer than one short line, even valid WHY comments — trim to the load-bearing fact, move the rest to the commit message. The surrounding file's comment density is NOT a defense: AI-written files are self-consistently verbose, so judge against the one-line bar in absolute terms, not against the file
- The same rationale stated in more than one place (e.g. at a constant and again in its consumer's docblock) — keep it in exactly one
- Transitional comments that narrate how the code changed ("used to…", "previously…", "now we…", "renamed from…", "pre-fix"). The new state should read as if it was always this way; the before/after belongs in the commit message, not the code
- Temporal comments that go stale on the next nearby edit — references to line numbers, "see above/below", dates, or rationale too delicate to stay accurate
- Transitional/vestigial code introduced in this branch — scaffolding, params, flags, branches, helpers, or compat shims that an earlier iteration of the change needed but the final approach no longer uses. Trace each added symbol to a live caller; if the branch's own evolution orphaned it, delete it. (Leave pre-existing dead code you didn't introduce — flag it, don't remove it)
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
- Casts to any to get around type issues
- Any other style that is inconsistent with the file

Keep (do not strip):
- WHY comments that encode business rules, edge cases, or historical/external constraints — trimmed to the load-bearing fact
- JSDoc on core or shared APIs — you may tighten the wording, but don't delete the contract

Report at the end with only a 1-3 sentence summary of what you changed
