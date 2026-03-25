---
name: ai-agents-workflow
description: >
  Build production-ready AI agents, automation workflows, and tool orchestrations with security-first patterns and deployment guides. This skill should be used when creating MCP servers, designing LangChain or LangGraph pipelines, building CrewAI or AutoGen multi-agent systems, wiring tool-using LLMs, implementing ReAct agent patterns, building prompt chains, connecting n8n or Zapier automations to AI models, or deploying agent workflows to production. Covers architecture patterns, security, tool sandboxing, cost optimization, and testing for both focused single-purpose automations and complex multi-agent systems. Also triggers on: MCP, FastMCP, LangChain, LangGraph, CrewAI, AutoGen, multi-agent, Zapier automation, Make automation, n8n workflow, webhook, cron job, tool integration, API orchestration, code execution agent, agent memory, agent state, prompt injection defense, OAuth flow for agents, A2A protocol, agentic loop, function calling, tool use, structured output, agent framework, "connect X to Y", "automate this process", "build an agent that", "I want a bot that", agent deployment, rate limiting for agents, cost ceiling for LLM agents.
license: MIT
---

# AI Agents & Workflow

Build production-ready agents. Security-first. Observability-out.

## Agent Architecture Patterns

### Pattern 1: Single-Purpose Tool Agent
Best for: focused automation, one input → one output

```
User Request → LLM → Tool Call → Result → LLM → Response
```

### Pattern 2: ReAct Loop
Best for: multi-step reasoning, unknown number of tool calls needed

```
Thought → Action → Observation → Thought → Action → ... → Final Answer
```

### Pattern 3: Multi-Agent Pipeline
Best for: parallel work, specialized agents, quality gates

```
Orchestrator → [Agent A, Agent B, Agent C] → Aggregator → Output
```

### Pattern 4: Human-in-the-Loop
Best for: high-stakes decisions, approval gates

```
Agent → Checkpoint → Human Approval → Continue / Reject
```

## MCP Server Scaffold (FastMCP)

```python
from fastmcp import FastMCP

mcp = FastMCP("my-server")

@mcp.tool()
def search_database(query: str, limit: int = 10) -> list[dict]:
    """Search the database for records matching query."""
    # validate inputs — never trust caller
    if len(query) > 500:
        raise ValueError("Query too long")
    return db.search(query, limit=limit)

if __name__ == "__main__":
    mcp.run()
```

## Security Checklist for Agents

- [ ] **Prompt injection defense**: Never concatenate user input directly into system prompt
- [ ] **Tool sandboxing**: Code execution tools run in isolated containers
- [ ] **Scope limiting**: Each agent has only the tools it needs (principle of least privilege)
- [ ] **Cost ceiling**: Set max tokens/requests per session; alert on anomalies
- [ ] **Output validation**: Structured output schema enforced before acting on agent results
- [ ] **Audit logging**: Every tool call logged with inputs, outputs, and caller identity
- [ ] **Rate limiting**: Per-user and per-session limits on agent invocations
- [ ] **Secret handling**: API keys injected at runtime, never in agent instructions

## Cost Optimization

| Strategy | Impact |
|---|---|
| Cache repeated tool calls | High — avoid redundant API/DB calls |
| Use smaller model for routing/triage | Medium — reserve large model for reasoning |
| Limit context window aggressively | High — trim irrelevant history |
| Parallel tool calls where safe | Medium — reduce latency and sequential cost |
| Set hard token budgets per step | Critical — prevents runaway costs |

## Observability Requirements

Every production agent needs:

```python
# Trace every tool call
logger.info("tool_call", extra={
    "tool": tool_name,
    "inputs": sanitized_inputs,
    "duration_ms": elapsed,
    "tokens_used": response.usage.total_tokens,
    "session_id": session_id
})
```

## Testing Agents

- **Unit test tools in isolation** — mock the LLM, test tool logic directly
- **Integration test the loop** — use deterministic test LLM responses
- **Adversarial inputs** — test prompt injection, oversized inputs, unexpected tool outputs
- **Cost regression tests** — assert token count stays within bounds for standard scenarios
