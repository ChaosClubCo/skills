---
name: create-slash-commands
description: Expert guidance for creating, structuring, and using Claude Code slash commands — reusable prompt shortcuts defined as Markdown files with YAML frontmatter. This skill should be used when the user asks to create a custom /command, build a slash command, add a new command to Claude Code, understand command structure, write a command.md file, configure YAML frontmatter for commands, understand project-level vs user-level commands, pass arguments to slash commands, create a parameterized command, turn a recurring task into a shortcut, make a reusable prompt template, understand the .claude/commands/ directory, build a workflow trigger, or debug a slash command that isn't appearing. Also triggers on: how do I make a /deploy command, custom /command, make a shortcut for a task, reusable command template, automate with a slash command, slash command not showing up, slash command not working, custom prompt shortcut, build a /review command, how to call a command with arguments, slash command YAML, command file not loading, where do I put command files, create a project slash command, user-level command, how do I create a /standup command.
license: Complete terms in LICENSE.txt
---

# Create Slash Commands

This skill provides expert guidance for creating Claude Code slash commands — reusable prompt shortcuts triggered by `/command-name` that can be scoped to a project or available globally.

## What Are Slash Commands?

Slash commands are Markdown files stored in specific directories that Claude Code loads as named commands. When a user types `/command-name`, Claude executes the prompt defined in that file, optionally with arguments substituted in.

## Directory Structure

```
# Project-scoped (checked into repo, shared with team)
.claude/
  commands/
    deploy.md
    review.md
    standup.md

# User-scoped (available in all projects for that user)
~/.claude/
  commands/
    daily-summary.md
    my-review.md
```

## Command File Format

Each command is a `.md` file with optional YAML frontmatter:

```markdown
---
description: Run a full code review on the current branch
---

Review the code changes in the current branch against main.

Focus on:
- Security vulnerabilities and input validation
- Performance regressions
- Missing error handling
- Test coverage gaps

For each issue found, provide: severity, file + line, explanation, and suggested fix.
```

## Parameterized Commands

Use `$ARGUMENTS` to accept user-provided input at invocation time:

```markdown
---
description: Create a GitHub issue for the given topic
---

Create a well-structured GitHub issue for: $ARGUMENTS

Include:
- Clear title
- Problem description
- Acceptance criteria
- Suggested labels
```

User invokes with: `/create-issue Add dark mode support to dashboard`

## Built-in Variables

Claude Code injects these variables automatically into command content:

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | Text the user typed after the slash command name |
| `{{project_root}}` | Absolute path to the project root |

## Best Practices

1. Name commands with kebab-case matching their file name: `code-review.md` → `/code-review`
2. Write descriptions in YAML frontmatter — they appear in the slash command picker UI
3. Be specific in the prompt body — treat it like a high-quality system prompt for that task
4. Keep commands focused on one workflow; avoid mega-commands that do too many things
5. Version-control project commands in `.claude/commands/` so the team shares them
6. For commands that need file context, instruct Claude to read specific files or use `{{project_root}}`

## Debugging

If a slash command isn't appearing:
- Verify the file is in `.claude/commands/` (project) or `~/.claude/commands/` (user)
- Ensure the file extension is `.md`
- Check YAML frontmatter is valid (no tabs, proper indentation)
- Restart Claude Code to reload commands
