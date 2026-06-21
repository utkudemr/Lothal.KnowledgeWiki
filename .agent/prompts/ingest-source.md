# Ingest Source Prompt Template

Use this prompt template as a guide when ingesting a new source into the wiki.

## Instructions

1. Copy this template into a new message.
2. The helper script replaces the braced source-path placeholder with the raw source file path.
3. Use a path under raw/, for example:
   - `raw/articles/karpathy-llm-wiki.md`
   - `raw/repos/aspire-agents-md.md`
   - `raw/interview-questions/why-isnt-everything-async.md`
4. Follow AGENTS.md workflow rules carefully.

## Template

---

You are ingesting a new source into Lothal.KnowledgeWiki.

**Source Path:**

{{SOURCE_PATH}}

**Repository Rules:**
- Read AGENTS.md first.
- Read the raw source file from {{SOURCE_PATH}}.
- Do not modify anything under raw/.
- Create or update relevant pages under wiki/.
- Write generated wiki content in Turkish unless the source requires English.
- Preserve source references using the raw file path.
- Avoid duplicate pages; update existing pages when the topic already exists.
- Use relative markdown links.
- Use lowercase kebab-case file names.
- Update wiki/index.md when pages are created or meaningfully updated.
- Append an entry to wiki/log.md.
- After creating or updating wiki pages, run `.\scripts\validate-wiki.ps1` to perform deterministic validation.
- Do not recommend a final commit until review and deterministic validation pass (Errors: 0).

---

**Your Tasks:**

1. **Analyze the source** carefully and identify:
   - Main idea or concept
   - Important technical claims
   - Practical examples
   - Relevance for .NET backend engineering
   - Relevance for distributed systems or microservices
   - Relevance for agent workflows
   - Interview preparation value
   - Personal project connections

2. **Check for duplicates** in existing wiki pages:
   - concepts/
   - syntheses/
   - interview/
   - projects/
   - companies/
   - people/

3. **Decide what to create or update:**
   - New concept page? (Use concepts/ template from AGENTS.md)
   - Update existing concept?
   - Create synthesis page? (Use syntheses/ template)
   - Create interview note? (Use interview/ template)
   - Update project note? (Use projects/ template)
   - Company/job analysis? (Use companies/ template)

4. **Structure your output using the Learning Output Rule:**
   1. Explain the main insight
   2. Connect to existing knowledge
   3. Highlight practical implications
   4. List related concepts
   5. Note interview relevance
   6. Suggest next steps
   7. Flag open questions

5. **Follow these rules:**
   - Keep raw sources immutable
   - Add source references using {{SOURCE_PATH}}
   - Link to related wiki pages
   - Update wiki/index.md if you create new pages
   - Append to wiki/log.md with the format:
     ```
     ## YYYY-MM-DD - action - Source Title
     
     Source:
     - `{{SOURCE_PATH}}`
     
     Created:
     - `wiki/concepts/example.md`
     
     Updated:
     - `wiki/index.md`
     - `wiki/log.md`
     
     Notes:
     - Brief explanation
     ```

6. **Final summary** (include in your response):
   - Created files
   - Updated files
   - Important decisions
   - Recommended reading order
   - Validation reminder
   - Open questions

Prefer synthesis pages first in the recommended reading order when a synthesis page exists.

---

## Example Response Structure

When you finish the ingest:

```
## Ingest Summary

### Main Insight
[Explain what this source teaches]

### Connection to Existing Knowledge
[Link to wiki/projects/lothal-knowledgewiki.md and other relevant pages]

### Practical Implications
[Why this matters for .NET, microservices, etc.]

### Related Concepts to Explore
- [wiki/concepts/example.md](../concepts/example.md)
- [wiki/syntheses/example.md](../syntheses/example.md)

### Interview Relevance
[How this appears in interviews]

### Next Steps
- Follow-up source: ...
- Concept to deepen: ...
- Project application: ...

### Recommended Reading Order
1. `wiki/syntheses/example.md`
2. `wiki/concepts/example.md`

### Open Questions
- ?
- ?

---

### Files Created
- `wiki/concepts/example.md`

### Files Updated
- `wiki/index.md`
- `wiki/log.md`

### Important Decisions
- Reason for content organization

### Remaining Questions
- Areas needing clarification

### Validation Reminder
Run:

```powershell
.\scripts\validate-wiki.ps1
```
```

