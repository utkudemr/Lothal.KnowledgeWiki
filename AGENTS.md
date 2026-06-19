# Knowledge Wiki Agent Instructions

You are maintaining a markdown-based technical knowledge base for a .NET backend developer.

The goal of this repository is to turn scattered technical sources into durable, linked, reviewable and reusable learning artifacts.

This repository is not only a note archive. It is an experiment in agent-assisted knowledge management.

## Core Purpose

When a source is added to `raw/`, your job is to process it into the `wiki/` directory.

You should help transform sources such as articles, tweets, GitHub repositories, job postings, interview questions, videos and chat summaries into:

* technical concept pages
* synthesis pages
* interview-ready notes
* project-related notes
* company/job analysis notes
* reusable learning material

The wiki should become more useful over time.

## Main Responsibilities

When working in this repository, you must:

* Read and follow this file before making changes.
* Keep raw sources immutable.
* Maintain the wiki under `wiki/`.
* Prefer updating existing pages over creating duplicate pages.
* Create useful links between related pages.
* Keep explanations practical and engineering-focused.
* Preserve source references.
* Update `wiki/index.md` after meaningful wiki changes.
* Append an entry to `wiki/log.md` after each ingest or major update.
* Use Turkish by default unless the source or task requires English.
* Make the content useful for software engineering learning, interview preparation and project work.

## Repository Structure

```text
Lothal.KnowledgeWiki/
  README.md
  AGENTS.md

  raw/
    articles/
    tweets/
    repos/
    videos/
    job-postings/
    interview-questions/
    chat-summaries/

  wiki/
    index.md
    log.md

    concepts/
    syntheses/
    interview/
    projects/
    companies/
    people/
```

## Directory Rules

### `raw/`

The `raw/` directory contains original or manually captured sources.

Do not modify files under `raw/` unless the user explicitly asks.

Raw sources are the source of truth.

Source categories:

* `raw/articles/` for articles, blog posts and essays
* `raw/tweets/` for tweets, X posts, LinkedIn posts and short social content
* `raw/repos/` for GitHub repository notes, README files and codebase observations
* `raw/videos/` for video transcripts, summaries or notes
* `raw/job-postings/` for job descriptions and role requirements
* `raw/interview-questions/` for interview questions and prepared answers
* `raw/chat-summaries/` for summaries exported from conversations

## Raw Source Template Rule

New raw source files should preferably use `.agent/templates/source.md`.

Raw source files should include:

* title
* source URL
* captured date
* source type
* context notes
* raw content

Files under `raw/` are still immutable after being added unless the user explicitly asks for a change.

`Context Notes` should explain why the source was added, not only what it contains.

Good context notes help the agent produce better wiki output because they clarify the learning goal, project relevance, interview relevance or engineering question behind the source.

### `wiki/`

The `wiki/` directory contains processed knowledge pages.

* `wiki/index.md` is the main navigation index.
* `wiki/log.md` is the chronological audit log.
* `wiki/concepts/` contains reusable technical concept pages.
* `wiki/syntheses/` contains cross-source comparisons and conclusions.
* `wiki/interview/` contains interview-ready answers.
* `wiki/projects/` contains notes related to personal projects.
* `wiki/companies/` contains company, job posting and role analysis notes.
* `wiki/people/` contains notes about important authors, engineers or public technical figures.

## Ingest Workflow

When ingesting a new source:

1. Read the source carefully.
2. Identify:

   * main idea
   * important concepts
   * technical claims
   * examples
   * practical implications
   * relevance for .NET backend engineering
   * relevance for distributed systems, microservices or agent workflows
   * interview relevance
   * project relevance
3. Decide whether to:

   * create a new concept page
   * update an existing concept page
   * create a synthesis page
   * create an interview note
   * create a project note
   * create a company/job note
4. Avoid duplicate pages.
5. Add links between related pages.
6. Add source references using the raw file path.
7. Update `wiki/index.md`.
8. Append an entry to `wiki/log.md`.

## Writing Style

Use Turkish by default.

Prefer:

* clear explanations
* practical backend examples
* .NET examples when relevant
* distributed systems context when relevant
* microservice examples when relevant
* interview-ready summaries
* project-oriented notes
* concrete takeaways
* simple but technically accurate language

Avoid:

* vague motivational writing
* unnecessary repetition
* unsupported claims
* modifying raw sources
* creating too many tiny pages
* over-engineered explanations
* content that cannot be traced back to a source or a clear reasoning step

## Link Style

Use relative markdown links.

Examples:

```md
[LLM Wiki](../concepts/llm-wiki.md)
[RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)
[Agent Harness](../concepts/agent-harness.md)
```

When linking from `wiki/index.md`, use paths relative to `wiki/index.md`.

Examples:

```md
[LLM Wiki](concepts/llm-wiki.md)
[RAG vs LLM Wiki](syntheses/rag-vs-llm-wiki.md)
```

## File Naming Rules

Use lowercase kebab-case file names.

Good examples:

```text
llm-wiki.md
rag-vs-llm-wiki.md
agent-harness.md
dotnet-async.md
sliding-window-rate-limit.md
why-isnt-everything-async.md
```

Bad examples:

```text
LLM Wiki.md
RAG_vs_LLM_Wiki.md
AgentHarness.md
New Note.md
```

## Concept Page Template

Use this structure for concept pages:

```md
# Title

## Short Definition

A short and clear definition of the concept.

## Why It Matters

Explain why this concept matters in real software engineering work.

## Key Ideas

- Main idea 1
- Main idea 2
- Main idea 3

## Example

Give a concrete example.

## .NET / Backend Relevance

Explain how this concept relates to .NET backend development, APIs, microservices, databases, messaging, observability, distributed systems or agent workflows.

## Interview Relevance

Explain how this topic may appear in interviews and how to answer it.

## Related Pages

- [Related Page](../concepts/example.md)

## Source References

- `raw/path/to/source.md`

## Open Questions

- List unclear points, assumptions or topics that need more research.
```

## Synthesis Page Template

Use this structure for synthesis pages:

```md
# Title

## Summary

Shortly explain what is being compared or synthesized.

## Compared Ideas

List the ideas, sources or approaches being compared.

## Key Differences

Explain the most important differences.

## Practical Takeaways

Explain what a software engineer should take away from this synthesis.

## When To Use Which

Explain when each approach is useful.

## .NET / Backend Relevance

Explain how this synthesis relates to .NET backend development, microservices, distributed systems, APIs, messaging, observability, persistence or agent workflows.

## Related Pages

- [Related Page](../concepts/example.md)

## Source References

- `raw/path/to/source.md`

## Open Questions

- List unclear points, assumptions or topics that need more research.
```

## Interview Page Template

Use this structure for interview pages:

```md
# Question

Write the interview question as the title.

## Short Answer

Give a concise answer.

## Strong Answer

Give a stronger, more complete answer.

## Example From Experience

Connect the answer to realistic software engineering experience.

## Common Mistakes

List common weak answers, misunderstandings or traps.

## Related Concepts

- [Related Concept](../concepts/example.md)

## Source References

- `raw/path/to/source.md`
```

## Project Page Template

Use this structure for project pages:

```md
# Project Name

## Purpose

Explain what the project is for.

## Current State

Summarize the current state.

## Important Concepts

List related concepts.

## Architecture Notes

Explain important architecture decisions.

## Agent Workflow Notes

Explain how agents, prompts, instructions or automation are used in this project.

## Next Ideas

List possible next steps.

## Related Pages

- [Related Page](../concepts/example.md)

## Source References

- `raw/path/to/source.md`
```

## Company / Job Posting Page Template

Use this structure for company or job posting pages:

```md
# Company / Role Name

## Summary

Summarize the company, role or job posting.

## Required Skills

List the important required skills.

## Nice To Have Skills

List the optional or preferred skills.

## Match With My Experience

Explain how the requirements match existing .NET backend, microservice, retail, POS, event-driven or full-stack experience.

## Gaps

List missing or weaker areas.

## Interview Preparation Notes

List possible interview topics based on the job posting.

## Related Pages

- [Related Page](../concepts/example.md)

## Source References

- `raw/path/to/source.md`
```

## Source Reference Rule

Every wiki page created or updated from a source must include a `Source References` section.

Use raw file paths.

Example:

```md
## Source References

- `raw/articles/karpathy-llm-wiki.md`
```

If a page is updated based on multiple sources, keep all relevant source references.

Example:

```md
## Source References

- `raw/articles/karpathy-llm-wiki.md`
- `raw/repos/aspire-agents-md.md`
- `raw/tweets/agent-harness-example.md`
```

## Index Update Rules

Update `wiki/index.md` whenever you create or significantly update wiki pages.

The index should help a human quickly navigate the knowledge base.

Use this structure:

```md
# Knowledge Wiki Index

This is the main navigation page for the knowledge wiki.

## Core Concepts

- [Example Concept](concepts/example.md) - Short explanation.

## Syntheses

- [Example Synthesis](syntheses/example.md) - Short explanation.

## Interview Notes

- [Example Interview Note](interview/example.md) - Short explanation.

## Projects

- [Example Project](projects/example.md) - Short explanation.

## Companies / Job Notes

- [Example Company Note](companies/example.md) - Short explanation.

## People

- [Example Person](people/example.md) - Short explanation.
```

Do not leave stale entries in the index.

## Log Update Rules

Append entries to `wiki/log.md` after each ingest or major update.

Use this format:

```md
## YYYY-MM-DD - ingest - Source Title

Source:
- `raw/articles/example.md`

Created:
- `wiki/concepts/example.md`

Updated:
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Short explanation of what changed.
```

For non-ingest updates, use one of these action types:

* `ingest`
* `update`
* `synthesis`
* `cleanup`
* `review`

Examples:

```md
## 2026-06-18 - ingest - Karpathy LLM Wiki

Source:
- `raw/articles/karpathy-llm-wiki.md`

Created:
- `wiki/concepts/llm-wiki.md`
- `wiki/syntheses/rag-vs-llm-wiki.md`

Updated:
- `wiki/concepts/rag.md`
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added initial explanation of LLM-maintained wiki as a persistent knowledge layer.
- Connected the idea to RAG, agent workflows and backend-style read models.
```

## Quality Rules

Before finishing, check:

* Did you read `AGENTS.md`?
* Did you avoid modifying `raw/`?
* Is the source path preserved?
* Is `wiki/index.md` updated?
* Is `wiki/log.md` updated?
* Are related pages linked?
* Did you avoid duplicating existing content?
* Did you write in Turkish by default?
* Did you keep the explanation practical?
* Did you connect the topic to .NET/backend engineering when relevant?
* Did you add interview relevance when useful?
* Did you add project relevance when useful?

## Duplicate Handling

Before creating a new page:

1. Check whether a related page already exists.
2. Prefer updating the existing page if the topic is the same or very close.
3. Create a new page only if the topic is meaningfully distinct.

Example:

Do not create all of these separately unless needed:

```text
agent-harness.md
agentic-harness.md
ai-agent-harness.md
harness-for-agents.md
```

Prefer one canonical page:

```text
agent-harness.md
```

## Contradictions and Unclear Claims

If a source conflicts with another source or an existing wiki page:

1. Do not silently overwrite the older information.
2. Add a note explaining the conflict.
3. Add the issue to an `Open Questions` section.
4. Preserve both source references.

Example:

```md
## Open Questions

- Source A describes agent harness as an execution boundary, while Source B uses it more broadly as a prompt/workflow structure. Need to clarify terminology.
```

## Practical Framing Rules

When possible, explain topics using examples from:

* .NET backend development
* ASP.NET Core APIs
* microservices
* CQRS / MediatR
* PostgreSQL, MSSQL, Couchbase, Redis or Elasticsearch
* messaging systems such as NATS or RabbitMQ
* distributed locks
* outbox/inbox
* rate limiting
* observability
* agent workflows
* software interviews
* personal projects such as Lothal.FlowRecovery or Lothal.Mediator

Do not force these examples if they are irrelevant.

## Interview Extraction Rule

If a source contains a concept that may appear in interviews, consider creating or updating an interview note under `wiki/interview/`.

Examples:

```text
why-isnt-everything-async.md
microservice-production-experience.md
uuid-as-primary-key.md
sliding-window-rate-limit.md
pgbouncer-connection-pooling.md
```

Interview pages should be practical and answer-focused.

## Project Relevance Rule

If a source can improve a personal project idea or existing project, update the related project page under `wiki/projects/`.

Examples:

```text
lothal-flowrecovery.md
lothal-mediator.md
lothal-knowledgewiki.md
```

Project notes should include realistic next steps, not vague ideas.

## Final Response Rule

When you finish a task, summarize:

* created files
* updated files
* important decisions
* any open questions

Keep the summary concise.

## Learning Output Rule

After ingesting a source or performing a significant update, structure your output to support active learning:

1. **Explain the main insight** – Describe what the source teaches or the key decision made.
2. **Connect to existing knowledge** – Show how this relates to existing wiki pages and engineering experience.
3. **Highlight practical implications** – Explain why this matters for .NET backend development, microservices, distributed systems or agent workflows.
4. **List related concepts** – Identify other wiki pages or topics that should be explored alongside this.
5. **Note interview relevance** – Mention if and how this concept appears in technical interviews.
6. **Suggest next steps** – Propose logical follow-up sources, related concepts to deepen, or project applications.
7. **Flag open questions** – Call out unclear points or assumptions that need clarification.

This approach ensures that ingested knowledge becomes actionable learning material, not just archived facts. Use the [Reading Guide](wiki/reading-guide.md) to understand how to best consume and retain generated wiki outputs.
