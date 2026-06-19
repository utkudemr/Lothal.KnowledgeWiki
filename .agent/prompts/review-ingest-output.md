# Review Ingest Output Prompt Template

Use this prompt template to review and validate an ingest output before finalizing it.

## Instructions

1. Copy this template into a new message.
2. Paste the ingest output or summary into INGEST_OUTPUT section.
3. Provide the source path in the SOURCE_PATH field.
4. Run the prompt to validate quality and completeness.

## Template

---

You are reviewing an ingest output for Lothal.KnowledgeWiki.

**Source:** SOURCE_PATH

**Repository Rules (from AGENTS.md):**
- Turkish is default for user-facing content
- All wiki pages must have Source References
- Links use relative markdown format
- File names are lowercase kebab-case
- Source references use raw file paths
- Duplicate pages should be avoided
- All pages link to related content

**Ingest Output to Review:**

INGEST_OUTPUT

---

## Review Checklist

Validate the following:

### Content Quality

- [ ] Main insight is clearly explained (1 sentence?)
- [ ] Connection to existing wiki pages is explicit
- [ ] Practical implications are specific (mentions .NET, microservices, or projects)
- [ ] Related concepts are listed with correct links
- [ ] Interview relevance is noted (if applicable)
- [ ] Next steps are actionable
- [ ] Open questions are specific (not vague)

### Repository Rules Compliance

- [ ] Source references include raw file path(s)
- [ ] All files use lowercase kebab-case names
- [ ] Links are relative markdown format
- [ ] No duplicates of existing pages
- [ ] Turkish is used for user-facing content (unless source is English)
- [ ] No modifications to raw/ sources
- [ ] wiki/index.md is updated if new pages created
- [ ] wiki/log.md entry follows the format:
  ```
  ## YYYY-MM-DD - action - Title
  
  Source:
  - `raw/path/to/source.md`
  
  Created:
  - `wiki/path/to/file.md`
  
  Updated:
  - `wiki/index.md`
  - `wiki/log.md`
  
  Notes:
  - Brief explanation
  ```

### Learning Output Rule Compliance

- [ ] Main insight explained clearly
- [ ] Existing knowledge connections visible
- [ ] Practical implications stated
- [ ] Related concepts identified
- [ ] Interview relevance noted
- [ ] Next steps suggested
- [ ] Open questions flagged
- [ ] Recommended reading order prioritizes synthesis pages before concept pages when a synthesis page exists

### Wiki Template Compliance

If concept page created:
- [ ] Has Short Definition section
- [ ] Has Why It Matters section
- [ ] Has Key Ideas (bullet list)
- [ ] Has Example section
- [ ] Has .NET / Backend Relevance section
- [ ] Has Interview Relevance section
- [ ] Has Related Pages section
- [ ] Has Source References section
- [ ] Has Open Questions section

If synthesis page created:
- [ ] Has Summary section
- [ ] Has Compared Ideas list
- [ ] Has Key Differences section
- [ ] Has Practical Takeaways section
- [ ] Has When To Use Which section
- [ ] Has .NET / Backend Relevance section
- [ ] Has Related Pages section
- [ ] Has Source References section
- [ ] Has Open Questions section

If interview page created:
- [ ] Has Short Answer
- [ ] Has Strong Answer
- [ ] Has Example From Experience
- [ ] Has Common Mistakes
- [ ] Has Related Concepts
- [ ] Has Source References

### Common Issues to Check

- [ ] No placeholder text or incomplete sections
- [ ] No external URLs without context
- [ ] No unsupported technical claims
- [ ] No modifications to raw/ files
- [ ] File paths are correct and exist
- [ ] Links point to real wiki pages
- [ ] Turkish grammar and terminology correct
- [ ] No duplicate content from existing pages
- [ ] Source references are traceable

---

## Output Format

Please provide:

1. **Overall Assessment:** PASS / NEEDS REVISION / MAJOR ISSUES

2. **Strengths:** List 2-3 positive aspects of the ingest

3. **Required Fixes:** List any issues that must be corrected before finalization

4. **Suggestions for Improvement:** List optional enhancements

5. **Recommended Reading Order:** List the files the user should read first. Prefer synthesis pages first when they exist.

6. **Checklist Results:** Summary of checklist compliance

7. **Final Recommendation:**
   - ✅ Ready to commit
   - ⚠️ Ready with minor notes
   - ❌ Needs revision before commit

---

## Example Review Response

```
## Review Result: PASS

### Strengths
- Clear connection to existing RAG and Agent Workflow concepts
- Practical .NET microservice example provided
- Interview relevance section identifies realistic scenarios

### Required Fixes
- None

### Suggestions for Improvement
- Consider adding a related synthesis page about "LLM Wiki vs Vector DB" for database comparison

### Checklist Results
- ✅ All content quality checks pass
- ✅ Repository rules compliance 100%
- ✅ Learning Output Rule sections present
- ✅ Template structure correct

### Final Recommendation
✅ Ready to commit

Files to commit:
- wiki/concepts/example.md
- wiki/index.md (updated)
- wiki/log.md (updated)
```

