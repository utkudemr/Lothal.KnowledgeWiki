# Ingest Source Prompt Template

Use this prompt template as a guide when ingesting a new source into the wiki.

## Instructions

1. Copy this template into a new message.
2. Fill in the SOURCE_CONTENT section with the source material.
3. Run the prompt with the Explore agent for codebase context if needed.
4. Follow AGENTS.md workflow rules carefully.

## Template

---

You are ingesting a new source into Lothal.KnowledgeWiki.

**Repository Structure:**
- Read AGENTS.md carefully
- All wiki files are in Turkish unless the source requires English
- Raw sources are immutable under raw/
- Use relative markdown links
- Preserve source references

**Source Material:**

SOURCE_CONTENT

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
   - Use kebab-case filenames
   - Add source references (`raw/path/to/source.md`)
   - Link to related wiki pages
   - Update wiki/index.md if you create new pages
   - Append to wiki/log.md with the format:
     ```
     ## YYYY-MM-DD - action - Source Title
     
     Source:
     - `raw/path/to/source.md`
     
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
   - Open questions

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
```

