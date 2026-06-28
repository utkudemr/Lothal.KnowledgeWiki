# Lothal.KnowledgeWiki

LLM agent'larıyla çalışan kişisel teknik asistan akışı için public engine/framework.

Projenin amacı; dağınık teknik kaynakları kalıcı, bağlantılı ve gözden geçirilebilir öğrenme çıktılarına dönüştüren scriptleri, promptları, validation kurallarını, okuma yapısını ve public-safe örnekleri geliştirmektir. Kullanıcının gerçek özel bilgi belleği bu public repository içinde değil, ayrı bir `KnowledgeMemory` klasöründe yaşayacaktır.

## Purpose

Geleneksel chat tabanlı öğrenmede değerli sentezler zaman içinde kaybolur. Lothal.KnowledgeWiki bu sorunu çözen sistemin public ve tekrar kullanılabilir motorudur; kullanıcının sınırsız büyüyebilecek özel kaynak arşivi değildir.

Public repository şunları içerir:

- scriptler ve engine/framework mantığı
- promptlar ve agent talimatları
- validation workflow'u
- reading path yapısı
- dokümantasyon
- public-safe örnekler ve generated wiki notları

Özel `KnowledgeMemory` ise tam raw capture'ları, kişisel özetleri, üretilmiş notları, private reading çıktılarını, inbox capture'larını, run artefact'larını ve Obsidian-readable notları içerir.

## Architecture: Public Engine + Private KnowledgeMemory

```text
Lothal.KnowledgeWiki (public)       KnowledgeMemory (private)
scripts, prompts, validation       inbox, raw captures
reading-path structure             generated/personal notes
documentation, safe examples       run artifacts, reading outputs
engine/framework improvements      Obsidian-readable memory
```

Bu ayrımın nedenleri:

- Public repo kullanıcının tüm kişisel belleğine dönüşmemelidir.
- Raw source capture'ları ve üretilmiş özel notlar sürekli ve sınırsız büyüyebilir.
- Kişisel asistan belleği private kalmalı ve kullanıcının seçtiği yöntemle senkronize edilmelidir.
- Public repo her özel kaynağı saklamak yerine sistemi açıklamalı, doğrulamalı ve iyileştirmelidir.

`KnowledgeMemory` bir Git repository olmak zorunda değildir. OneDrive, Google Drive, Obsidian Sync, Syncthing veya başka bir private sync mekanizmasıyla tutulabilir.

Önerilen yapı:

```text
KnowledgeMemory/
  inbox/
  raw/
    articles/
    tweets/
    repos/
    videos/
  notes/
    concepts/
    syntheses/
    interview/
    projects/
    reading-paths/
  runs/
  home.md
```

2026-06-28 migration'ında mevcut full raw capture'lar `KnowledgeMemory/raw/` altına kopyalanıp doğrulandıktan sonra public çalışma ağacından kaldırıldı. Generated `wiki/` notları yerinde kaldı. Git geçmişi yeniden yazılmadığı için eski raw dosyalar önceki commit'lerde bulunabilir.

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

Bugünkü external-memory akışı:

1. Put the original source under `KnowledgeMemory/raw/`.
2. Ask the agent to ingest it according to `AGENTS.md`.
3. Agent creates or updates pages under `wiki/`.
4. Agent updates `wiki/index.md`.
5. Agent appends an entry to `wiki/log.md`.

Public wiki sayfaları private capture'ları `vault://raw/<type>/<file>.md` ile referanslar. Bu logical URI repository içinde çözülmez. `capture-and-prepare-ingest.ps1` bu akış için `-MemoryPath` parametresini destekler. Generated private note ve run artefact'larını taşıma bu migration'ın kapsamında değildir.

## Legacy Repo-Local Helper Workflow

Bu bölümdeki repo-relative komutlar mevcut helper scriptlerin geriye dönük kullanımını belgeler; aktif public çalışma ağacında raw capture tutulması önerilmez. Yeni capture'lar için aşağıdaki `-MemoryPath` akışını kullanın.

1. Create a raw source file:

   ```powershell
   .\scripts\new-source.ps1 article "Article Title" "https://example.com/article"
   ```

2. Fill the generated raw source file:
   - Context Notes
   - Raw Content

   To import Raw Content from the clipboard, first copy article markdown/text from the browser, reader mode, or MarkDownload, then run:

   ```powershell
   .\scripts\import-clipboard-source.ps1 raw/articles/example.md
   ```

   This helper fills only the `{{RAW_CONTENT}}` placeholder. It does not fetch URL content or call an LLM.

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

5. After ingest completes, copy its summary and save it:

   ```powershell
   .\scripts\save-ingest-summary.ps1 raw/articles/<generated-file>.md
   ```

   Then generate a review prompt with the saved summary already inserted:

   ```powershell
   .\scripts\review-prompt.ps1 raw/articles/<generated-file>.md .agent/runs/<source-slug>/ingest-summary.md
   ```

   Paste the copied, fully filled prompt into the IDE agent/chat. Calling `review-prompt.ps1` with only the source path remains supported and leaves the `INGEST_OUTPUT` placeholder for manual replacement.

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

## Save Ingest Summary and Prepare Review

After the ingest agent finishes, copy its summary and run:

```powershell
.\scripts\save-ingest-summary.ps1 <legacy-repo-local-source-path>
```

The helper archives the clipboard text under `.agent/runs/<source-slug>/ingest-summary.md`, records the source path and prints the next `review-prompt.ps1` command. Run that command to copy a review prompt with the ingest summary already inserted. Neither helper calls an LLM or creates a commit.

## Capture and Prepare Ingest

For most article, tweet and thread captures, the preferred workflow is:

1. Copy the source markdown/text from the browser, reader mode, or MarkDownload.
2. Run the wrapper:

   ```powershell
   .\scripts\capture-and-prepare-ingest.ps1 article "Article Title" "https://example.com/article" -MemoryPath "G:\My Drive\KnowledgeMemory"
   ```

3. Review the created private raw source file and optionally improve its Context Notes.
4. Paste the ingest prompt, which the helper copied to the clipboard, into the IDE agent/chat.

The helper creates the raw file under external `KnowledgeMemory`, imports clipboard content, adds default Context Notes, prepares a prompt containing a `vault://raw/...` reference and runs validation. It does not fetch URLs, call an LLM or create commits.

### Private KnowledgeMemory Capture

Raw capture'ı public repository dışında private veya synced bir KnowledgeMemory klasörüne yazmak için mevcut bir klasörü `-MemoryPath` ile verin:

```powershell
.\scripts\capture-and-prepare-ingest.ps1 tweet "Agent Harness vs Classic Agent" "https://x.com/..." -MemoryPath "G:\My Drive\KnowledgeMemory"
```

Bu mod source dosyasını `<MemoryPath>/raw/<type-folder>/` altında oluşturur ve prompt içine `vault://raw/<type-folder>/<filename>.md` logical reference'ını ekler. Private raw source Git'e alınmaz; ingest çıktısı şimdilik public KnowledgeWiki repository içindeki `wiki/` katmanına yazılır. `MemoryPath` klasörü önceden var olmalıdır.

## Phase 2 Validation Workflow

After ingest and review, run:

```powershell
.\scripts\validate-wiki.ps1
```

The validator checks:

- required files exist
- relative markdown links inside `wiki/**/*.md` resolve
- wiki pages have Source References
- repo-relative `raw/.../*.md` references point to existing public files
- `vault://raw/...` logical references are accepted without requiring private files to exist in the public repository
- placeholder/template leftovers are reported

If validation returns errors, fix them before committing. If validation returns warnings, review them before committing.

A clean result should show:

- Errors: 0
- Warnings: 0

## Reading With Obsidian

Repository root'u opsiyonel olarak Obsidian vault olarak acilabilir. Okumaya [`wiki/home.md`](wiki/home.md) sayfasindan baslayin; buradaki konu bazli rotalar, `wiki/` altindaki sayfalari onerilen sirayla gezdirir.

Obsidian Git'in, validation scriptlerinin veya agent workflow'unun yerine gecmez. Duzenleme, prompt hazirlama, agent calistirma, validation ve commit akisi icin Rider veya VS Code ana ortam olarak kalir.

Onerilen kullanim ayrimi:

- Rider / VS Code: duzenleme, scriptler, promptlar, agent workflow'u, validation, diff review ve commit.
- Obsidian: wiki'nin okuma katmani; reading path'ler, backlinks, graph/canvas kesfi ve tekrar calisma.

Obsidian kullanilirsa `.obsidian/` klasoru varsayilan olarak Git'e alinmamalidir. Obsidian ayarlari daha sonra bilincli sekilde versiyonlanmak istenirse bu karar ayrica verilebilir.

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

Architecture direction: public KnowledgeWiki Engine + private KnowledgeMemory boundary is active. Existing raw captures were migrated out of the public working tree; `-MemoryPath` is the preferred capture mode.

Next: add generated-note support under `KnowledgeMemory/notes/` and provide a KnowledgeMemory bootstrap workflow.
