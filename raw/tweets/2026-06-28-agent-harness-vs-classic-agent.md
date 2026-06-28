# Agent Harness vs Classic Agent

## Source Metadata

- Title: Agent Harness vs Classic Agent
- Source URL: https://x.com/kmeanskaran/status/2066139671412035728
- Captured At: 2026-06-28
- Source Type: tweet

> Source type examples: Article, Gist, GitHub Repository File, Tweet, LinkedIn Post, Video Transcript, Job Posting, Interview Question, Chat Summary

## Context Notes

This source was captured to understand and summarize the topic for the knowledge wiki.

Focus areas:
- Main idea
- Practical engineering implications
- Agent workflow relevance
- .NET/backend relevance
- Interview relevance
- Personal project connections

## Raw Content

You have probably used a classic AI agent before. You type a prompt, the model replies, and the interaction ends. That works fine for simple tasks. But the moment you try to automate something real, something that spans multiple steps, touches external systems, or needs to remember what happened five minutes ago, the whole thing falls apart.

The model is not the problem. The architecture is.

This is exactly what agent harnesses are built to fix. And once you understand the difference, you will see why the harness is not an optional upgrade. It is a fundamentally different way of building with AI.

## 

What a Classic Agent Actually Is

A classic AI agent is a language model sitting behind a chat interface. You send a prompt. The model generates a response. That is the entire loop.

Every request is stateless. The model has no awareness of what it did in the previous step. It cannot break a task into parts. It cannot write to a file, run a script, check whether its output was correct, or try again if something went wrong.

-   Answering a specific question
    
-   Summarizing a document
    
-   Drafting a short piece of text
    

It breaks down immediately when the task requires:

-   Multiple dependent steps
    
-   External tool calls
    
-   Quality validation
    
-   Memory across steps
    
-   Recovery from partial failure
    

A classic agent is a single shot. The harness is what turns that into a reliable workflow.

## 

What an Agent Harness Is

An agent harness is the system built around a model. It is the layer that gives a language model the ability to plan, act, remember, delegate, and recover.

The model provides intelligence. The harness provides execution.

[

![Resim](https://pbs.twimg.com/media/HKscxqHawAAes7M?format=jpg&name=900x900)



](https://x.com/kmeanskaran/article/2066139671412035728/media/2065776493524074496)

LangChain’s DeepAgents is one of the clearest implementations of this pattern. It is an open source agent harness built on LangChain and LangGraph, designed specifically for long-running, multi-step tasks. It ships with planning tools, a virtual filesystem, subagent delegation, context engineering, persistent memory, skills, sandboxed code execution, and human-in-the-loop support all out of the box.

The stack underneath it is layered deliberately:

-   LangGraph is the graph runtime that handles durable execution, streaming, and stateful workflows
    
-   LangChain’s create\_agent is a minimal harness on top of LangGraph, good for lightweight agents
    
-   DeepAgents is the full harness on top of create\_agent, bundling everything a long-running agent needs
    

You use DeepAgents when you want the complete harness without building it yourself. You drop to create\_agent when you want something thinner. You drop to LangGraph directly when you need a fully custom execution graph.

## 

Why You Should Prefer the Harness

Before going into each component, it is worth being direct about why this matters.

A classic agent fails not because the underlying model is bad but because the model has no scaffolding to do sustained work. It cannot hold state across steps, cannot verify its own output, cannot delegate to a focused subagent, and cannot recover gracefully when something breaks midway through a complex task.

The harness solves all of these. It turns a capable model into a capable system. If your task has more than two or three sequential steps, involves any external data source, or needs results you can trust rather than results you have to manually verify, the harness is the correct choice. Classic agents are for demos and simple assistants. Harnesses are for work that actually ships.

## 

The Components in Detail

## 

1\. Planning

The first thing a harnessed agent does when given a complex task is create a plan. DeepAgents ships with a built-in write\_todos tool that forces the model to decompose the objective into steps before taking any action.

This might sound trivial. It is not. Without explicit planning, a model tends to jump straight into execution and lose coherence after the first few steps. With a visible todo list, the agent knows exactly where it is in the task, what comes next, and what is still outstanding. It can also adapt the plan mid-task as it learns more.

For a research-to-article workflow, the plan might look like:

1.  Extract key sections from the source paper
    
2.  Research supplementary background on the topic
    
3.  Draft the article from structured notes
    
4.  Review the draft against the source for accuracy
    
5.  Finalize and format for publication
    

Each step is tracked. If step 3 fails, the agent does not restart from step 1. It retries from where it failed, with the filesystem holding everything that was already done.

## 

2\. Backends and Virtual Filesystem

The virtual filesystem is one of the most important components in the harness and the one most people overlook.

A classic agent has no persistent workspace. Every piece of context lives in the prompt, and as the task grows, the context window fills up and older information gets dropped. For anything beyond a short task, this is a serious problem.

DeepAgents exposes a filesystem surface to the agent through built-in tools (ls, read\_file, write\_file, edit\_file, glob, grep). These tools operate through a pluggable backend. The backend is what decides where files actually live and how they persist.

DeepAgents ships with several built-in backends:

StateBackend (default) is ephemeral. Files are stored in LangGraph agent state for the current thread. This is the scratch pad: great for intermediate results that the agent writes during a task and reads back later. Files persist across multiple agent turns on the same thread via checkpoints, and they are shared between the main agent and its subagents.

FilesystemBackend reads and writes real files under a configurable root directory on your local machine. You specify the root, and the agent has access to everything under it. Best for local development CLIs and coding assistants where the agent needs to interact with your actual project files.

StoreBackend uses the LangGraph cross-thread store, which means files persist across threads, not just within one. This is the backend for long-term storage: memories, instructions, or reference data that should survive across multiple conversations.

CompositeBackend is the router. It lets you point different filesystem paths to different backends. For example, the default workspace can be ephemeral (StateBackend) but anything under /memories/ goes to the durable StoreBackend. This is maximally flexible and is how most production setups are configured.

The read\_file tool natively supports multimodal content across all backends. Images (.png, .jpg, .gif, .webp), video, audio, PDFs, and PowerPoint files are all returned as multimodal content blocks that the model can actually read and reason about.

The practical effect is that intermediate work gets offloaded to files rather than staying in the context window. Research notes go to a file. The draft goes to a file. Reviewer feedback goes to a file. The context stays clean, and no work is lost between steps.

## 

3\. Context Engineering

Context engineering is the difference between an agent that works for five minutes and one that works for five hours.

The official LangChain docs define it as providing the right information and tools in the right format so your agent can accomplish tasks reliably. Deep agents have access to several kinds of context, and the harness manages all of them:

Input context is what goes into the agent’s prompt at startup: the system prompt, loaded memories, loaded skills. This is static and applied at the beginning of each run.

Runtime context is configuration passed at invoke time: user metadata, API keys, connection details. It propagates automatically to subagents.

Context compression is the automatic mechanism that keeps the agent within its context window limits as a task runs long. As conversation history grows, the harness summarizes it. When tool results come back large, the harness offloads them to the filesystem and lets the agent read them back in pieces. Skills and memory are loaded on demand, not all at once.

Context isolation uses subagents to quarantine heavy work. A research subagent processes ten documents in its own context window and returns only a clean summary to the main agent. The main agent never sees the raw noise, which means it stays sharp and does not lose track of earlier steps.

Long-term memory is persistent storage across threads using the virtual filesystem, which feeds back into input context on future runs.

This layered approach is what lets a deep agent run for a long time, across many steps and many tool calls, without degrading. A classic agent has no equivalent. It fills up and fails.

## 

4\. Subagents

Complex tasks are almost always made of distinct, separable responsibilities. A research task needs a researcher. A writing task needs a writer. A review task needs a reviewer. Trying to do all of these inside one agent with one context window is inefficient and unreliable.

A harnessed agent solves this by spawning subagents. Each subagent runs in its own isolated context window, with its own tools and system prompt, focused on exactly one job. The main orchestrator sees only the final result from each subagent, not all the intermediate steps that subagent took to get there.

This has two major benefits. First, context stays clean. The orchestrator is not drowning in research noise when it is trying to write. Second, subagents can run in parallel where tasks are independent, cutting total execution time. DeepAgents supports async subagents for exactly this: fire off multiple tasks concurrently and collect results when they finish.

Subagents share the filesystem backend with their parent. Any file a subagent writes is available to the main agent and to other subagents. This is how they coordinate: one subagent writes research notes to a file, another reads those notes and drafts the article.

In DeepAgents, any LangGraph CompiledStateGraph can be passed in as a subagent. This means custom orchestration logic plugs in alongside the built-in harness defaults without any friction. You can also configure subagents with different models, different tools, and different permissions than the parent agent.

## 

5\. Memory

Memory in a harness operates at two levels.

Short-term memory is task-scoped. It holds everything relevant to the current job: the plan, the current draft, the working notes, the review feedback. This lives in the filesystem (typically the StateBackend) and is cleared or archived when the task completes.

Long-term memory persists across sessions and across threads. User preferences, writing style rules, domain knowledge, past corrections. This uses the StoreBackend or a CompositeBackend with a durable route (like /memories/). The agent loads what is relevant from the memory store at the start of a session and carries that context forward.

The LangChain docs describe memory as what lets agents learn and improve across conversations. The harness loads memories into the system prompt as input context, and the agent can also write new memories to the filesystem during a run. This means the agent is not just consuming persistent knowledge but actively updating it based on what it learns.

Classic agents have neither form of memory. Every session starts from zero. Every interaction requires the user to re-explain context that should already be known. Long-term memory is what turns a capable agent into one that actually learns how you work and improves over time.

## 

6\. Skills

Skills are reusable agent capabilities that provide specialized workflows and domain knowledge. They follow the Agent Skills specification and are loaded from the filesystem when relevant.

Think of a skill as a detailed briefing for a specific type of work. A research skill tells the agent how to structure extracted notes, what metadata to capture, and how to handle conflicting sources. A writing skill defines tone, format, target reading level, and citation style. A reviewing skill defines quality criteria, what to flag, and how to return feedback.

DeepAgents supports both community skills (from the Agent Skills ecosystem at

) and LangChain’s own skill library (langchain-skills on GitHub), which provides ready-to-use skills that improve agent performance on LangChain ecosystem tasks. You can also create your own.

Skills are not hardcoded into the agent. They are files that can be updated based on real usage. If a reviewing skill produces consistently weak feedback on a certain type of content, you update the skill file and every future reviewer subagent automatically improves.

This is what makes harnessed agents maintainable at scale. You are not rewriting prompts scattered across different parts of your code. You are editing a single skill file that propagates everywhere it is used.

## 

7\. Sandboxes

Agents generate code, interact with filesystems, and run shell commands. Because you cannot predict what an agent might do, the execution environment should be isolated so it cannot access credentials, files, or the network on your host system. Sandboxes provide this isolation.

In DeepAgents, sandboxes are a type of backend. Unlike standard backends (State, Filesystem, Store) which only expose file operations, sandbox backends also give the agent an execute tool for running arbitrary shell commands. When you configure a sandbox backend, the agent gets all the standard filesystem tools plus shell execution inside a secure boundary.

This is especially important for:

-   Coding agents that need to run shell commands, use git, clone repositories, and run build/test pipelines
    
-   Data analysis agents that need to load files, install dependencies, and run scripts
    
-   Any agent that executes untrusted or generated code
    

DeepAgents supports multiple sandbox providers: Modal, Daytona, Deno, and a local VFS option for development. Sandboxes can be scoped per thread (each conversation gets its own sandbox) or per assistant (shared across conversations). Files can be seeded into the sandbox before the agent starts, and artifacts can be retrieved after execution completes.

The core principle is simple: the agent can do anything inside the sandbox but nothing outside it. Your host system, credentials, and network stay protected.

## 

8\. Human-in-the-Loop

Not every decision should be made autonomously. Some actions carry real-world consequences: sending a message, writing to a production database, deleting a file, deploying code. These should have a human approval step before execution.

DeepAgents supports this through LangGraph’s interrupt capabilities. You configure which tools require approval using the interrupt\_on parameter, and the harness handles the rest.

Each tool can be configured independently:

-   True enables interrupts with default behavior: the human can approve, edit, or reject the tool call
    
-   False disables interrupts for that tool
    
-   Custom configuration lets you restrict the allowed decisions (for example, approve and reject only, no editing)
    

```python
agent = create_deep_agent( model="anthropic:claude-sonnet-4-6", tools=[delete_file, read_file, send_email], interrupt_on={ "delete_file": True, "read_file": False, "send_email": {"allowed_decisions": ["approve", "reject"]}, }, checkpointer=checkpointer, )
```

When the agent hits an interrupt, it pauses, surfaces the tool call details to the user, and waits. The user can approve it as-is, edit the arguments before execution, or reject it entirely. If rejected, the agent revises its approach and tries again.

Subagent interrupts are also supported: if a subagent’s tool requires approval, the interrupt bubbles up to the human rather than being silently executed.

This is not an add-on. It is a first-class primitive in the harness. And it is what makes harnessed agents trustworthy for tasks that classic agents could never be given access to in the first place.

## 

9\. Tools

A classic agent can generate text. A harnessed agent can take actions.

DeepAgents can call any tool you define: plain Python functions, LangChain

\-decorated functions, tool dicts, and tools from any MCP (Model Context Protocol) server. You pass them directly to create\_deep\_agent via the tools= parameter, and they sit alongside the built-in harness tools.

The schema is inferred automatically from your function signature and docstring. You do not need to define a separate schema in most cases.

from deepagents import create\_deep\_agent

```python
def internet_search(query: str, max_results: int = 5): """Run a web search""" return search_client.search(query, max_results=max_results) agent = create_deep_agent( model="anthropic:claude-sonnet-4-6", tools=[internet_search], )
```

MCP support is where this gets powerful. MCP is an open protocol that connects agents to a growing ecosystem of external servers (databases, APIs, file systems, browsers, and more) through a standard interface. Instead of writing custom integration code for each service, you point your deep agent at an MCP server and it gets all the tools that server exposes. One interface, any service.

On top of your custom tools, every deep agent inherits a set of built-in harness tools: ls, read\_file, write\_file, edit\_file, glob, grep for filesystem operations, execute for shell commands (sandbox backends only), task for spawning subagents, and write\_todos for planning. These are always available without configuration.

## 

Where the Harness Wins: Real Use Cases

1\. Deep Research Pipelines

A classic agent summarizes one document. A harnessed agent surveys ten sources, cross-references findings, identifies contradictions, and synthesizes a structured report. Each source gets its own research subagent. Notes are stored to the filesystem. A synthesis subagent works from accumulated files rather than from memory. The output is reproducible and reviewable.

2\. Autonomous Coding Agents

Fixing a bug means reading the relevant files, understanding the surrounding context, writing the fix, running tests, reading the output, and iterating. A classic agent can write code. It cannot run it, read the test results, and loop back. A harnessed agent with a sandbox backend can do the full loop: read, write, execute, observe, revise. All inside an isolated environment that protects your host system.

3\. Multi-Stage Content Pipelines

Research, outline, draft, fact-check, review, format. Each stage is a separate subagent with a specific skill loaded. Intermediate files persist between stages. A failure in the review step does not mean rerunning research from scratch.

4\. Iterative Workflows with Feedback Gates

Some tasks are loops by nature. A design agent that produces a spec, routes it for review, gets feedback, revises, and repeats needs state across iterations. The harness tracks iteration count, stores each version, loads previous reviewer comments as context, and pauses for human sign-off when needed via interrupt\_on.

## 

Comparing the Two Directly

Classic Agent → One prompt, one output

Agent Harness → Multi-step workflow with planning and todo tracking

Agent Harness → Short-term (StateBackend) + long-term (StoreBackend) persistent memory

Classic Agent → Very limited

Agent Harness → Custom functions, MCP servers, APIs, databases, file I/O

Agent Harness → Auto-summarization, offloading, compression, isolation via subagents

Agent Harness → Isolated context, parallel execution, async support

Agent Harness → Modular, reusable, updateable, community ecosystem

Agent Harness → Sandboxed shell via Modal, Daytona, Deno, or local VFS

Agent Harness → Per-tool interrupt configuration with approve/edit/reject

Agent Harness → Retry from last successful step, filesystem holds completed work

Classic Agent → Usually tied to one provider

Agent Harness → Any tool-calling model (OpenAI, Anthropic, Google, open-weight via Ollama/vLLM)

## 

The Bottom Line

A language model is a reasoning engine. It is powerful but it is stateless, toolless, and memoryless by default.

An agent harness is what makes that reasoning engine useful for sustained, real-world work. Tools, backends, context engineering, subagents, memory, skills, sandboxes, human-in-the-loop, planning. Each component addresses a specific failure mode of the classic agent. Together they close the gap between a capable model and a capable system.

The model gives intelligence. The harness gives execution.

I am currently building a one complete end-to-end Agent Harness and will deploy on Railway using CI/CD and AgentOps setup.

Follow me on

for more update

LangChain Deep Agents Documentation:

The Anatomy of an Agent Harness:
