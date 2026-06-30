# Ingest Source Prompt Template

Use this template for private ingestion with `capture-and-prepare-ingest.ps1 -MemoryPath`. The helper-generated prompt fills the external source, note-folder and insight targets. Repo-local ingestion is a legacy/demo workflow for intentionally public-safe synthetic examples only.

## Template

---

You are ingesting a private source with the public Lothal.KnowledgeWiki engine.

**Public Repository:** `{{REPOSITORY_ROOT}}`

**External Raw Source:** `{{SOURCE_PATH}}`

**Logical Source Reference:** `{{VAULT_REFERENCE}}`

**External Targets:**

- Notes root: `{{NOTES_ROOT}}`
- Concepts: `{{CONCEPTS_PATH}}`
- Syntheses: `{{SYNTHESES_PATH}}`
- Interview: `{{INTERVIEW_PATH}}`
- Projects: `{{PROJECTS_PATH}}`
- Reading paths: `{{READING_PATHS_PATH}}`
- Private insight: `{{PRIVATE_INSIGHT_PATH}}`

## Rules

- Read `AGENTS.md` from the public repository first.
- Read but never modify the external raw source.
- MemoryPath mode overrides repo-local ingest instructions: do not create or update source-specific generated pages under public `wiki/`.
- Create or update reusable knowledge notes only below the supplied external `notes/` targets.
- Keep personal reflection, company/career connections, private reading history and “how this applies to me” material in the supplied `insights/` target, not in `notes/`.
- Use lowercase kebab-case file names and relative links between external notes.
- Add `{{VAULT_REFERENCE}}` under `Source References`; never place the physical raw path in generated knowledge notes.
- Do not expose physical local paths inside generated notes. Physical paths may appear only in private operational content under MemoryPath when necessary.
- Do not copy raw content verbatim into notes or insights; synthesize it.
- Do not commit MemoryPath files to the public repository.
- Public repository changes should normally be limited to source-independent scripts, prompts, validators and documentation—not source-specific output.
- Do not update public `wiki/index.md` or `wiki/log.md` for a MemoryPath ingest.
- Write in Turkish by default unless the source requires English.

## Tasks

1. Analyze the main idea, technical claims, examples, .NET/backend relevance, distributed-systems relevance, agent-workflow relevance and interview value.
2. Check existing external notes and update a canonical note instead of creating duplicates.
3. Create only useful outputs among concepts, syntheses, interview, projects and reading paths.
4. Create or update the private insight note with:
   - Benim için ana fikir
   - Bildiklerimle bağlantı
   - Pratik backend/.NET çıkarımları
   - Mikroservis/distributed systems bağlantısı
   - Mülakat açısından nasıl anlatılır
   - Kişisel eksikler / sonraki okuma
   - Kısa hafıza kartı
5. Finish with created/updated external files, important decisions, reading order and open questions. Mention public repository changes separately (normally none), without reproducing private insight content.

---

## Legacy / Demo Mode

When `-MemoryPath` is not supplied, existing repo-local helpers may generate public `wiki/` pages only from public-safe synthetic sources. In that mode, follow the repo-local index, log and validation rules in `AGENTS.md`.
