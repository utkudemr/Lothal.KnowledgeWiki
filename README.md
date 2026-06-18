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

## Status

Phase 1: Manual markdown wiki and agent-assisted ingestion.