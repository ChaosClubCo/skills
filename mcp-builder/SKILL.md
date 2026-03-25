---
name: mcp-builder
description: >
  Build production-ready MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed, secure tools. This skill should be used when building an MCP server to expose an API or service to Claude, when implementing MCP tools in Python (FastMCP) or Node/TypeScript (MCP SDK), when designing tool schemas for LLM consumption, when adding MCP support to an existing service, or when debugging MCP server connectivity issues. Covers tool design, input validation, error handling, authentication patterns, and deployment. Also triggers on: MCP server, FastMCP, Model Context Protocol, MCP tool, MCP resource, MCP prompt, Claude tool use, build an MCP, create an MCP server, expose API to Claude, connect service to Claude, MCP stdio transport, MCP HTTP transport, MCP authentication, tool schema design, tool input validation, MCP server not connecting, MCP tool not appearing, debug MCP, MCP deployment, "make this available to Claude", "Claude can't see my tool", write MCP tools, MCP SDK.
license: MIT
---

# MCP Builder

Build well-designed MCP servers that LLMs can reliably use.

## Core Concepts

MCP (Model Context Protocol) lets Claude interact with external services through three primitives:

| Primitive | Purpose | Example |
|---|---|---|
| **Tools** | Execute actions | `search_database`, `create_ticket` |
| **Resources** | Read data | `file://path`, `db://table` |
| **Prompts** | Reusable templates | Pre-built conversation starters |

Most MCP servers expose Tools. Start there.

## FastMCP Server (Python)

```python
from fastmcp import FastMCP
from typing import Optional

mcp = FastMCP("my-service")

@mcp.tool()
def search_records(
    query: str,
    limit: int = 10,
    filter_by: Optional[str] = None
) -> list[dict]:
    """
    Search records matching a query string.

    Args:
        query: Search terms. Supports partial matches.
        limit: Max results to return (1-100).
        filter_by: Optional field to filter on (e.g. "status:active").

    Returns:
        List of matching records with id, title, and metadata.
    """
    # Validate all inputs — never trust the caller
    if not query or len(query) > 500:
        raise ValueError("query must be 1-500 characters")
    if not 1 <= limit <= 100:
        raise ValueError("limit must be 1-100")

    return db.search(query=query, limit=limit, filter_by=filter_by)

if __name__ == "__main__":
    mcp.run()  # stdio transport by default
```

## Node/TypeScript Server

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

const server = new McpServer({ name: "my-service", version: "1.0.0" });

server.tool(
  "search_records",
  { query: z.string().min(1).max(500), limit: z.number().min(1).max(100).default(10) },
  async ({ query, limit }) => {
    const results = await db.search(query, limit);
    return { content: [{ type: "text", text: JSON.stringify(results) }] };
  }
);
```

## Tool Design Principles

**1. One tool, one purpose.** Don't combine `search_and_update` — split into `search` and `update`.

**2. Descriptive docstrings.** The LLM reads your docstring to decide when to call the tool. Be specific about inputs, outputs, and edge cases.

**3. Return structured data.** JSON > prose for tool outputs. The LLM will summarize it for the user.

**4. Fail clearly.** Raise exceptions with actionable messages. "Invalid date format: use YYYY-MM-DD" is better than "Bad input".

**5. Idempotent writes.** If a tool creates or modifies data, make it safe to call twice with the same inputs.

## Security Checklist

- [ ] Validate all inputs before processing (type, range, length)
- [ ] Never concatenate user input into SQL queries
- [ ] Rate limit per session/user
- [ ] Log all tool calls with sanitized inputs
- [ ] Authenticate callers if the service handles sensitive data
- [ ] Scope permissions to minimum required (read-only unless write is needed)

## Claude Desktop Config

```json
{
  "mcpServers": {
    "my-service": {
      "command": "python",
      "args": ["/path/to/server.py"],
      "env": {
        "API_KEY": "your-key-here"
      }
    }
  }
}
```

## Debugging

Common issues:
- **Tool not appearing**: Check `mcp.run()` is called; check Claude Desktop config path
- **Tool call fails silently**: Add `try/except` with explicit error logging to stderr
- **Timeout**: Wrap slow operations in async; set reasonable timeouts on external calls
- **Auth errors**: Verify env vars are set in the MCP server config, not just your shell
