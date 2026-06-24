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
