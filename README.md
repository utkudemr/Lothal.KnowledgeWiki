# Lothal.KnowledgeWiki

A markdown-based technical knowledge base maintained with LLM agents.

The goal is to turn scattered technical sources such as articles, tweets,
GitHub repositories, job postings, interview questions and personal notes into
durable, linked and reviewable learning artifacts.

## Purpose

Traditional chat-based learning loses useful synthesis over time.
This repository experiments with a persistent wiki layer maintained by agents.

## Source Types

- Articles
- Tweets / LinkedIn posts
- GitHub repositories
- Videos
- Job postings
- Interview questions
- Chat summaries
- Personal project notes

## Workflow

1. Put the original source under `raw/`.
2. Ask the agent to ingest it according to `AGENTS.md`.
3. Agent creates or updates pages under `wiki/`.
4. Agent updates `wiki/index.md`.
5. Agent appends an entry to `wiki/log.md`.

## Phase 1.5 Usage Workflow

1. Create a raw source file:

   ```powershell
   .\scripts\new-source.ps1 article "Article Title" "https://example.com/article"
   ```

2. Fill the generated raw source file:
   - Context Notes
   - Raw Content

3. Commit the raw source:

   ```powershell
   git add raw/
   git commit -m "add article title source"
   ```

4. Generate an ingest prompt:

   ```powershell
   .\scripts\ingest-prompt.ps1 raw/articles/<generated-file>.md
   ```

   Paste the copied prompt into the IDE agent/chat.

5. After ingest completes, generate a review prompt:

   ```powershell
   .\scripts\review-prompt.ps1 raw/articles/<generated-file>.md
   ```

   Paste the copied prompt into the IDE agent/chat and replace `INGEST_OUTPUT` with the ingest summary.

6. Review git diff.

7. Commit wiki changes:

   ```powershell
   git add wiki
   git commit -m "ingest article title source"
   ```

Notes:

- `raw/` is the immutable source archive.
- `wiki/` is the generated learning layer.
- `.agent/templates/source.md` defines the raw source format.
- `.agent/prompts/` contains reusable prompt templates.
- `scripts/` only generate files or prompts; they do not run agents or call external APIs.

## Phase 2 Validation Workflow

After ingest and review, run:

```powershell
.\scripts\validate-wiki.ps1
```

The validator checks:

- required files exist
- relative markdown links inside `wiki/**/*.md` resolve
- wiki pages have Source References
- `raw/...` references point to existing `raw/` files
- placeholder/template leftovers are reported

If validation returns errors, fix them before committing. If validation returns warnings, review them before committing.

A clean result should show:

- Errors: 0
- Warnings: 0

### Start Ingest Helper

To create a raw source file and prepare the ingest prompt in one step:

```powershell
.\scripts\start-ingest.ps1 article "Article Title" "[https://example.com/article](https://example.com/article)"
```

This helper creates the raw source file and prepares the ingest prompt, but it does not fetch content, call LLMs, modify wiki files or commit changes.

## Status

Phase 1: Manual markdown wiki and agent-assisted ingestion completed.

Phase 1.5: Helper scripts added for:
- raw source creation
- ingest prompt generation
- review prompt generation

Phase 2: Deterministic wiki validation MVP added with `scripts/validate-wiki.ps1`.

Phase 3 MVP: Start ingest helper added with `scripts/start-ingest.ps1`.

Next: test the workflow with a new article end-to-end.
