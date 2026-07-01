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
- Reading order: `{{READING_ORDER_PATH}}`
- Memory home: `{{HOME_PATH}}`
- Concept index: `{{CONCEPT_INDEX_PATH}}`
- Source graph: `{{SOURCE_GRAPH_PATH}}`
- Topic maps: `{{TOPIC_MAPS_PATH}}`

## Rules

- Read `AGENTS.md` from the public repository first.
- Read but never modify the external raw source.
- MemoryPath mode overrides repo-local ingest instructions: do not create or update source-specific generated pages under public `wiki/`.
- Create or update reusable knowledge notes only below the supplied external `notes/` targets.
- Before writing, inspect existing notes under concepts, syntheses, interview and reading-paths, plus concept-index.md and source-graph.md when present.
- Identify 3-7 related existing notes when possible. Classify concrete relationships as `builds-on`, `contrasts-with`, `complements`, `prerequisite`, `follow-up`, `similar-pattern`, `applied-example` or `broader-context`. Do not add speculative links or force the count.
- Every generated note includes `## Hafıza Bağlantıları`, with `### İlgili Notlar`, `### Bu kaynak neyi tamamlıyor?`, `### Bu kaynak hangi gerilimi veya farkı gösteriyor?` and `### Sonraki bağlanabilecek konular`. Use `[[note-name]] — relationship type: short reason` for related notes.
- Keep personal reflection, company/career connections, private reading history and “how this applies to me” material in the supplied `insights/` target, not in `notes/`.
- Use lowercase kebab-case file names and relative links between external notes.
- Add `{{VAULT_REFERENCE}}` under `Source References`; never place the physical raw path in generated knowledge notes.
- Do not expose physical local paths inside generated notes. Physical paths may appear only in private operational content under MemoryPath when necessary.
- Do not copy raw content verbatim into notes or insights; synthesize it.
- Do not commit MemoryPath files to the public repository.
- Public repository changes should normally be limited to source-independent scripts, prompts, validators and documentation—not source-specific output.
- Do not update public `wiki/index.md` or `wiki/log.md` for a MemoryPath ingest.
- Write in Turkish by default unless the source requires English.
- After generating notes and insights, create or update `{{READING_ORDER_PATH}}`.
- The reading-order note must contain the title, source type, `{{VAULT_REFERENCE}}`, created-note list, recommended reading order, why this order, and optional follow-up reading/questions.
- It also includes `## Bağlantılı Okuma` with `### Önce okunabilecekler`, `### Beraber okunabilecekler` and `### Sonra okunabilecekler`.
- Link to generated notes with Obsidian wiki links when possible; do not put physical paths in the links.
- Create `{{HOME_PATH}}` if missing. Otherwise append or update one link under `Recent Ingests`.
- The `home.md` entry links to the reading-order note and does not duplicate its contents.
- Reading-order and home outputs are private MemoryPath files and must never be copied or committed to the public repository.
- Create or update `{{CONCEPT_INDEX_PATH}}` as a lightweight topic-grouped index of note links and keywords, not a copy of note bodies.
- Create or update `{{SOURCE_GRAPH_PATH}}` with the source-to-note outputs and concrete note-to-note relationships, including relationship types and short reasons.
- Create or update a lowercase kebab-case file under `{{TOPIC_MAPS_PATH}}` only when a coherent topic map is clearly useful.

## Tasks

1. Analyze the main idea, technical claims, examples, .NET/backend relevance, distributed-systems relevance, agent-workflow relevance and interview value.
2. Inspect the existing external notes and maps; update a canonical note instead of creating duplicates.
3. Create only useful outputs among concepts, syntheses, interview, projects and reading paths.
4. Create or update the private insight note with:
   - Benim için ana fikir
   - Bildiklerimle bağlantı
   - Pratik backend/.NET çıkarımları
   - Mikroservis/distributed systems bağlantısı
   - Mülakat açısından nasıl anlatılır
   - Kişisel eksikler / sonraki okuma
   - Kısa hafıza kartı
5. Create the reading-order note, update the concept index and source graph, optionally update a useful topic map, then create/update the concise `Recent Ingests` home entry.
6. Finish with created/updated external files, map, reading-order and home results, important decisions and open questions. Mention public repository changes separately (normally none), without reproducing private insight content.

---

## Legacy / Demo Mode

When `-MemoryPath` is not supplied, existing repo-local helpers may generate public `wiki/` pages only from public-safe synthetic sources. In that mode, follow the repo-local index, log and validation rules in `AGENTS.md`.
