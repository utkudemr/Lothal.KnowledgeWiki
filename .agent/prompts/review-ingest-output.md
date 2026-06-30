# Review Ingest Output Prompt Template

Use this template to review a private MemoryPath ingest. Repo-local review remains a legacy/demo path for intentionally public-safe synthetic sources.

## Template

---

You are reviewing an external-memory ingest produced with the public Lothal.KnowledgeWiki engine.

**External Raw Source:** `{{SOURCE_PATH}}`

**Logical Source Reference:** `{{VAULT_REFERENCE}}`

**External Notes Root:** `{{NOTES_ROOT}}`

**Private Insight Target:** `{{PRIVATE_INSIGHT_PATH}}`

**Ingest Output to Review:**

INGEST_OUTPUT

## Review Checklist

### Storage Boundary

- [ ] The raw source was not modified.
- [ ] Concept, synthesis, interview, project and reading-path outputs are under external `notes/`.
- [ ] Personal reflections are under external `insights/`, not `notes/` or public `wiki/`.
- [ ] No source-specific generated page was created or updated under public `wiki/`.
- [ ] Public `wiki/index.md` and `wiki/log.md` were not changed for this private ingest.
- [ ] No MemoryPath file is proposed for commit to the public repository.
- [ ] Any public repository change is source-independent engine/framework work.

### Content and Traceability

- [ ] Generated notes are reusable, practical and Turkish by default.
- [ ] Existing external notes were checked to avoid duplicates.
- [ ] File names are lowercase kebab-case and links between notes are relative.
- [ ] Generated notes use `vault://raw/...` under `Source References`.
- [ ] Physical local paths do not appear in generated knowledge notes.
- [ ] Raw source content was summarized rather than copied verbatim.
- [ ] Main insight, existing-knowledge connection, practical implications, related concepts, interview relevance, next steps and open questions are covered where useful.
- [ ] Synthesis notes precede concept notes in the recommended reading order when applicable.

### Private Insight

- [ ] The insight note uses the required Turkish learning/reflection sections.
- [ ] Personal/company/career/private-reading reflections appear only in the insight note.
- [ ] Insight content is not reproduced in public files or the final summary.

### Public Engine Validation

- [ ] If public engine/framework files changed, `./scripts/validate-wiki.ps1` was run and reports `Errors: 0`.
- [ ] If the public repository did not change, validation is marked not required for the private output review.

## Output Format

1. Overall Assessment: PASS / NEEDS REVISION / MAJOR ISSUES
2. Required Fixes
3. Optional Improvements
4. External Files Reviewed
5. Storage-Boundary Result
6. Recommended Reading Order
7. Public Validation Result: PASS / WARNINGS / NOT REQUIRED / FAILED
8. Final Recommendation: PRIVATE_OUTPUT_READY / NEEDS_REVISION

Do not recommend committing external MemoryPath files to the public repository.

---

## Legacy / Demo Review

For a repo-local synthetic demo ingest, apply the `AGENTS.md` rules for `wiki/index.md`, `wiki/log.md`, relative wiki links and deterministic validation. Do not apply those repo-local write requirements to MemoryPath output.
