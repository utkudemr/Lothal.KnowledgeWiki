# Knowledge Wiki Log

This file tracks ingest operations and major wiki updates.

## 2026-06-18 - ingest - Karpathy LLM Wiki

Source:
- `raw/articles/karpathy-llm-wiki.md`

Created:
- `wiki/concepts/llm-wiki.md`
- `wiki/concepts/rag.md`
- `wiki/concepts/agent-workflow.md`
- `wiki/syntheses/rag-vs-llm-wiki.md`
- `wiki/projects/lothal-knowledgewiki.md`

Updated:
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added LLM Wiki as a persistent, compounding markdown knowledge layer.
- Compared LLM Wiki with RAG and connected the pattern to .NET backend knowledge work.
- Documented how the agent workflow applies directly to this repository.

## 2026-06-19 - ingest - Microsoft Aspire AGENTS.md

Source:
- `raw/repos/aspire-agents-md.md`

Created:
- `wiki/concepts/agent-instructions.md`
- `wiki/syntheses/coding-agent-vs-knowledge-wiki-agent.md`

Updated:
- `wiki/concepts/agent-workflow.md`
- `wiki/projects/lothal-knowledgewiki.md`
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added agent instructions as a reusable concept for repository-specific LLM guidance.
- Compared coding agent instructions with knowledge/wiki agent instructions.
- Extracted Aspire-inspired practices for repository rules, quality gates and maintainer guidance.

## 2026-06-19 - review - Microsoft Aspire AGENTS.md ingest

Source:
- `raw/repos/aspire-agents-md.md`

Created:
- None

Updated:
- `wiki/concepts/agent-instructions.md`
- `wiki/syntheses/coding-agent-vs-knowledge-wiki-agent.md`
- `wiki/log.md`

Notes:
- Reviewed the Aspire ingest output for source references, relative links, learning value and synthesis-first reading order.
- Clarified the practical quality-gate mapping between coding agents and knowledge/wiki agents.

## 2026-06-19 - update - Phase 1 Status Report

Source:
- `raw/articles/karpathy-llm-wiki.md`
- `raw/repos/aspire-agents-md.md`

Created:
- `wiki/projects/phase-1-status-report.md`

Updated:
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added a Turkish Phase 1 status report summarizing the current architecture, completed work, workflow, strengths, weaknesses and next steps.
- Linked the report from the main index under Projects.

## 2026-06-19 - update - Phase 1 Open Questions Decisions

Source:
- `raw/articles/karpathy-llm-wiki.md`
- `raw/repos/aspire-agents-md.md`

Created:
- None

Updated:
- `wiki/projects/phase-1-status-report.md`
- `wiki/log.md`

Notes:
- Resolved Phase 1.5 direction in favor of script-based prompt helpers before README or Obsidian notes.
- Resolved Phase 2 validation direction in favor of a .NET CLI instead of starting with PowerShell validation scripts.

## 2026-06-19 - update - Phase 1 Decisions Detail

Source:
- `raw/articles/karpathy-llm-wiki.md`
- `raw/repos/aspire-agents-md.md`

Created:
- None

Updated:
- `wiki/projects/phase-1-status-report.md`
- `wiki/log.md`

Notes:
- Expanded the Phase 1 open-question decisions with explicit rationale and priority order.
- Recorded that Phase 1.5 helper scripts will use PowerShell and Phase 2 validation CLI will be built with .NET.

## 2026-06-20 - ingest - Local-first Software

Source:
- `raw/articles/2026-06-20-local-first-software.md`

Created:
- `wiki/concepts/local-first-software.md`
- `wiki/concepts/crdt.md`
- `wiki/syntheses/cloud-first-vs-offline-first-vs-local-first.md`
- `wiki/interview/offline-first-ile-local-first-arasindaki-fark-nedir.md`

Updated:
- `wiki/projects/lothal-knowledgewiki.md`
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added local-first software as a practical architecture concept for ownership, offline work, sync and collaboration.
- Added CRDT as a reusable distributed systems concept connected to conflict-free collaboration.
- Compared cloud-first, offline-first and local-first for .NET backend, POS and microservice design.
- Extracted an interview-ready explanation of offline-first versus local-first.

## 2026-06-21 - update - Phase 2 Status Report

Source:
- `scripts/validate-wiki.ps1`
- `.github/workflows/validate-wiki.yml`
- `.agent/prompts/ingest-source.md`
- `.agent/prompts/review-ingest-output.md`
- `README.md`

Created:
- `wiki/projects/phase-2-status-report.md`

Updated:
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added a Turkish Phase 2 status report documenting deterministic validation and GitHub Actions validation.
- Recorded the current workflow, known limitations, important decisions and next validation candidates.

## 2026-06-21 - update - Automation Roadmap

Source:
- `wiki/projects/phase-2-status-report.md`
- `wiki/projects/phase-1-status-report.md`
- `scripts/new-source.ps1`
- `scripts/ingest-prompt.ps1`
- `scripts/review-prompt.ps1`
- `scripts/validate-wiki.ps1`
- `.github/workflows/validate-wiki.yml`
- `README.md`

Created:
- `wiki/projects/automation-roadmap.md`

Updated:
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added a Turkish automation roadmap for reducing manual ingest, review and validation workflow steps after Phase 2.
- Documented phased next candidates including start-ingest helper, review summary automation, run artifacts, validation ergonomics and commit assistance.

## 2026-06-21 - ingest - To Cache or Not to Cache

Source:
- `raw/articles/2026-06-21-to-cache-or-not-to-cache.md`

Created:
- `wiki/concepts/cache-karar-kriterleri.md`
- `wiki/syntheses/cache-vs-source-of-truth.md`
- `wiki/interview/cache-ne-zaman-kullanilmali.md`

Updated:
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added cache decision criteria as a reusable backend/system design concept.
- Compared cache with source of truth and connected the distinction to local-first and offline-first data models.
- Extracted an interview-ready answer for when cache should and should not be used.

## 2026-06-23 - update - Start Ingest Helper

Source:
- `scripts/new-source.ps1`
- `scripts/ingest-prompt.ps1`
- `README.md`
- `wiki/projects/automation-roadmap.md`

Created:
- `scripts/start-ingest.ps1`

Updated:
- `README.md`
- `wiki/projects/automation-roadmap.md`
- `wiki/log.md`

Notes:
- Added a Phase 3 MVP helper that creates a raw source file and prepares the ingest prompt through existing scripts.
- Documented that the helper does not fetch content, call LLMs, modify wiki pages or commit changes.

## 2026-06-23 - ingest - The Most Important Skill in the Age of AI Judgment

Source:
- `raw/articles/2026-06-23-the-most-important-skill-in-the-age-of-ai-judgment.md`

Created:
- `wiki/concepts/ai-caginda-judgment.md`
- `wiki/syntheses/prompt-playbook-vs-kalibre-judgment.md`
- `wiki/interview/ai-ciktilarini-nasil-degerlendirirsin.md`

Updated:
- `wiki/concepts/agent-workflow.md`
- `wiki/projects/lothal-knowledgewiki.md`
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added AI-era judgment as a reusable concept for evaluating LLM and agent output.
- Compared prompt playbooks with calibrated judgment and connected the idea to ingest, review and deterministic validation.
- Extracted an interview-ready answer for explaining mature AI usage in software engineering workflows.

## 2026-06-23 - review - The Most Important Skill in the Age of AI Judgment ingest

Source:
- `raw/articles/2026-06-23-the-most-important-skill-in-the-age-of-ai-judgment.md`

Created:
- None

Updated:
- `wiki/log.md`

Notes:
- Reviewed the AI judgment ingest for template completeness, source references, relative links and duplicate risk.
- Confirmed generated wiki content does not contain absolute local filesystem paths.
- Confirmed deterministic validation passes with zero errors and zero warnings.

## 2026-06-24 - update - Obsidian Reading Layer Documentation

Source:
- `README.md`
- `wiki/projects/automation-roadmap.md`

Created:
- None

Updated:
- `README.md`
- `wiki/projects/automation-roadmap.md`
- `wiki/log.md`

Notes:
- Documented Obsidian as an optional reading and browsing layer for the markdown wiki.
- Clarified that Rider/VS Code remain the editing, agent workflow, validation and commit environment.
- Added reading UX and future automation candidates to the automation roadmap.

## 2026-06-24 - update - Clipboard Raw Content Import Helper

Source:
- `scripts/import-clipboard-source.ps1`
- `README.md`

Created:
- `scripts/import-clipboard-source.ps1`

Updated:
- `README.md`
- `wiki/log.md`

Notes:
- Added a PowerShell helper for importing clipboard text into an existing raw source file's Raw Content placeholder.
- Documented that the helper does not fetch URLs, call LLMs or append content when the placeholder is missing.

## 2026-06-24 - ingest - Two-Agent Workflow for Agentic Development

Source:
- `raw/articles/2026-06-24-two-agent-workflow-for-agentic-development.md`

Created:
- `wiki/concepts/two-track-agentic-development.md`
- `wiki/syntheses/parallel-agent-vs-flow-efficiency.md`
- `wiki/interview/agentic-developmentta-neden-cok-agent-her-zaman-verimli-degildir.md`

Updated:
- `wiki/concepts/agent-workflow.md`
- `wiki/projects/lothal-knowledgewiki.md`
- `wiki/projects/automation-roadmap.md`
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added two-track agentic development as a reusable concept for separating spec, implementation and verification work.
- Compared parallel agent count with flow efficiency and bottleneck-aware workflow design.
- Extracted an interview-ready answer about why many parallel agents do not automatically mean higher productivity.

## 2026-06-27 - update - Capture and Prepare Ingest Workflow

Source:
- `scripts/capture-and-prepare-ingest.ps1`
- `README.md`
- `wiki/projects/automation-roadmap.md`

Created:
- `scripts/capture-and-prepare-ingest.ps1`

Updated:
- `README.md`
- `wiki/projects/automation-roadmap.md`
- `wiki/log.md`

Notes:
- Added a single-command wrapper that creates a raw source, imports clipboard content, fills default Context Notes, prepares the ingest prompt and runs validation.
- Made browser-captured markdown/text the preferred Phase 3.5 workflow for most article, tweet and thread sources.
- Kept URL fetching, LLM calls and commit creation outside the helper's responsibilities.

## 2026-06-27 - ingest - Agent Orchestration Explained

Source:
- `raw/tweets/2026-06-27-agent-orchestration-explained.md`

Created:
- `wiki/concepts/agent-orchestration.md`
- `wiki/syntheses/single-agent-vs-agent-orchestration.md`
- `wiki/interview/agent-orchestration-nedir-ve-ne-zaman-kullanilmalidir.md`

Updated:
- `wiki/concepts/agent-workflow.md`
- `wiki/projects/lothal-knowledgewiki.md`
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added agent orchestration as a canonical concept covering delegation, context boundaries, partial result aggregation and next-step decisions.
- Compared single-agent execution with orchestration using task independence, token cost and verification capacity as decision criteria.
- Connected orchestration to .NET coordinator/worker patterns and defined a cautious application model for KnowledgeWiki ingest work.

## 2026-06-27 - update - Reader-Friendly Home and Reading Paths

Source:
- `wiki/index.md`
- Existing pages under `wiki/concepts/`, `wiki/syntheses/` and `wiki/interview/`

Created:
- `wiki/home.md`
- `wiki/reading-paths/agentic-development.md`
- `wiki/reading-paths/backend-system-design.md`
- `wiki/reading-paths/caching-and-consistency.md`
- `wiki/reading-paths/local-first-and-offline.md`
- `wiki/reading-paths/interview-prep.md`

Updated:
- `README.md`
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Added a reader-oriented dashboard and five ordered topic paths for Obsidian and other markdown readers.
- Preferred synthesis pages before concepts and interview notes, and linked only to files that currently exist.
- Marked thin backend and interview topic areas as "To be expanded" without creating fake links.

## 2026-06-28 - ingest - Agent Harness vs Classic Agent

Source:
- `raw/tweets/2026-06-28-agent-harness-vs-classic-agent.md`

Created:
- `wiki/concepts/agent-harness.md`
- `wiki/syntheses/classic-agent-vs-agent-harness.md`
- `wiki/interview/agent-harness-nedir.md`

Updated:
- `wiki/concepts/agent-workflow.md`
- `wiki/concepts/agent-orchestration.md`
- `wiki/projects/lothal-knowledgewiki.md`
- `wiki/index.md`
- `wiki/log.md`

Notes:
- Defined agent harness as the execution and control layer around a model, distinct from optional multi-agent orchestration.
- Reframed the source's classic-agent comparison as a spectrum and preserved the terminology ambiguity as an open question.
- Connected harness design to .NET workflow state, idempotency, observability, sandboxing and human approval.

## 2026-06-28 - update - Run Archive and Review Automation

Source:
- `scripts/save-ingest-summary.ps1`
- `scripts/review-prompt.ps1`
- `README.md`
- `wiki/projects/automation-roadmap.md`

Created:
- `scripts/save-ingest-summary.ps1`

Updated:
- `scripts/review-prompt.ps1`
- `README.md`
- `wiki/projects/automation-roadmap.md`
- `wiki/log.md`

Notes:
- Added a clipboard-based helper that archives ingest summaries and their source paths under `.agent/runs/<source-slug>/`.
- Extended the review prompt helper with an optional summary path while preserving its single-argument workflow.
- Removed the manual ingest-output placeholder replacement step from the preferred review workflow without calling an LLM or creating commits.

## 2026-06-28 - update - Public KnowledgeWiki Engine and Private KnowledgeMemory Architecture

Source:
- Architecture decision provided for the Lothal.KnowledgeWiki project

Created:
- None

Updated:
- `AGENTS.md`
- `README.md`
- `wiki/projects/lothal-knowledgewiki.md`
- `wiki/projects/automation-roadmap.md`
- `wiki/log.md`

Notes:
- Defined Lothal.KnowledgeWiki as the public engine/framework for scripts, prompts, validation, reading structures, documentation and public-safe examples.
- Moved the long-term personal memory boundary to a separate private and optionally synced `KnowledgeMemory` folder for raw captures, notes, reading outputs and run artifacts.
- Documented the future `-MemoryPath` workflow without modifying scripts or removing existing public `raw/` and `wiki/` content.
