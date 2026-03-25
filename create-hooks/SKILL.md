---
name: create-hooks
description: Expert guidance for creating, configuring, and using Claude Code hooks to intercept tool calls, validate commands before execution, run scripts on lifecycle events, and automate workflows. This skill should be used when the user asks about hooks, setting up event listeners, PreToolUse hooks, PostToolUse hooks, Stop hooks, SessionStart hooks, UserPromptSubmit hooks, how to block or intercept a bash command, how to add a notification when Claude finishes a task, how to audit log all tool calls, hook configuration in settings.json, writing a shell script or Python hook handler, hook exit codes, stderr output in hooks, pre-execution validation, preventing certain commands from running, automating actions after tool use, or running a script when a session starts. Also triggers on: hook not firing, hook not working, how do I intercept a tool call, validate before running a command, block a command before execution, approve tool use, custom hook handler, shell hook, python hook script, event-driven automation in Claude Code, how do I prevent certain bash commands, add notifications to Claude, trigger on file save, hook configuration file, audit log tool calls, run a script on session start, block dangerous commands.
license: Complete terms in LICENSE.txt
---

# Create Hooks

This skill provides expert guidance for creating, configuring, and using Claude Code hooks — user-defined shell commands that execute automatically at specific points in the Claude Code lifecycle.

## What Are Hooks?

Hooks intercept and automate Claude Code's behavior at key lifecycle points, enabling:
- **Pre-execution validation**: Inspect and potentially block tool calls before they run
- **Post-execution automation**: React to tool results, update logs, trigger downstream actions
- **Session lifecycle management**: Run setup/teardown scripts on session start and stop
- **Observability**: Audit log all tool calls, inputs, and outputs to external systems

## Hook Types

| Hook Type | When It Fires | Common Use Cases |
|-----------|---------------|------------------|
| `PreToolUse` | Before any tool executes | Validate inputs, block dangerous commands, require confirmation |
| `PostToolUse` | After any tool executes | Log outputs, trigger follow-up actions, send notifications |
| `Stop` | When Claude stops responding | Notify user, save session state, run cleanup |
| `SessionStart` | When a new session begins | Load context, authenticate, run environment setup |
| `UserPromptSubmit` | When user sends a message | Pre-process input, add context injection, validate requests |

## Hook Configuration

Hooks are configured in Claude Code's `settings.json` (user-level: `~/.claude/settings.json`, project-level: `.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash /path/to/validate-bash.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "python3 /path/to/audit-logger.py"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "notify-send 'Claude finished' || osascript -e 'display notification \"Claude finished\"'"
          }
        ]
      }
    ]
  }
}
```

## Hook Input / Output Contract

- **Input**: Hook receives a JSON payload via stdin describing the event (tool name, inputs, tool outputs, etc.)
- **Output**:
  - Exit code `0` — allow the action to proceed
  - Exit code `2` — block the action (PreToolUse only); stderr message is shown to Claude so it can adjust
  - Any other exit code — non-blocking failure logged but execution continues

## Example: Block Dangerous Bash Commands

```bash
#!/usr/bin/env bash
# validate-bash.sh - blocks rm -rf at root level
INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

if echo "$CMD" | grep -qE 'rm\s+-rf\s+/[^/]'; then
  echo "Blocked: destructive rm -rf on system path detected" >&2
  exit 2
fi
exit 0
```

## Example: Audit Logger (PostToolUse)

```python
#!/usr/bin/env python3
# audit-logger.py - logs all tool calls to a JSONL file
import sys, json, datetime

payload = json.load(sys.stdin)
entry = {
    "timestamp": datetime.datetime.utcnow().isoformat(),
    "tool": payload.get("tool_name"),
    "input": payload.get("tool_input"),
    "output_preview": str(payload.get("tool_response", ""))[:200]
}
with open("/tmp/claude-audit.jsonl", "a") as f:
    f.write(json.dumps(entry) + "\n")
```

## Best Practices

1. Keep hooks fast — PreToolUse hooks run synchronously and block execution
2. Use `jq` to parse the JSON stdin payload robustly
3. On exit code 2, write a clear actionable message to stderr so Claude can course-correct
4. Test hooks independently: `echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' | bash your-hook.sh`
5. Use PostToolUse for async/slow actions (logging, notifications) to avoid blocking the tool call
6. Scope hooks to specific tools using `matcher` regex to avoid unintended interference
