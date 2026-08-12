---
name: colon
description: Use when the user message starts with `:` to interpret prompt shortcuts such as `:commit`, `:co`, `:push`, `:pu`, `:ship`, `:sh`, `:opencode TEXT`, `:oc TEXT`, `:todo TEXT`, `:to TEXT`, `:ok NUMBER`, `:do NUMBER`, `:learn TEXT`, `:le TEXT`, `:close`, or `:cl`; also use an explicit bare `$colon` invocation to list those shortcuts without executing one.
---

# Colon Shortcuts

Use this skill when the user message starts with `:`. The first token selects the shortcut; the remaining text is the
shortcut input. Do not treat incidental `:` characters inside normal prose as shortcuts. When the skill is explicitly
invoked without a leading-colon token, list the supported shortcuts and execute nothing.

Match the first token exactly against the shortcuts below. If it is unknown, report the supported shortcuts instead of
guessing a near match or executing the text as a shell command. Preserve the remaining input verbatim except for the
explicit trimming rule under `:opencode`.

When a shortcut matches, behave as if the user had written the corresponding prompt below.

## Prompt Expansions

### `:commit [MESSAGE_HINT]`, `:co [MESSAGE_HINT]`

Inspect the current git status and diff. Load `commits`. Stage only the changes that belong to this work, prepare an
accurate Conventional Commit message using `MESSAGE_HINT` only as guidance, create the commit, and do not push.

### `:push [REMOTE] [BRANCH]`, `:pu [REMOTE] [BRANCH]`

Inspect the current branch and upstream. Push the current branch, using `REMOTE` and `BRANCH` if provided. Do not create
a commit first. If history diverged, do not force push unless the user explicitly requested it or the conversation
already established that local history is authoritative.

### `:ship [MESSAGE_HINT]`, `:sh [MESSAGE_HINT]`

Inspect the repository, commit the current work using the `:commit` behavior, then push using the `:push` behavior. If
there is nothing to commit, skip the commit step and only push when the branch is ahead of its upstream.

### `:opencode [INSTRUCTION]`, `:oc [INSTRUCTION]`

Inspect the latest OpenCode session in the context selected by `INSTRUCTION`. First trim surrounding whitespace. If
`INSTRUCTION` is one non-empty word, treat it as a skill name: resolve that skill's source copy, preferring
`~/Dropbox/home/agents/skills/NAME`, then `~/Dropbox/home-/agents/skills/NAME`, then the installed copy. Behave as if
the user had written: "I just completed an OpenCode task with a weaker model using the NAME skill. Inspect the
operations in that session and identify which NAME skill instructions the weaker model misinterpreted, or which
instructions it technically interpreted correctly but struggled with enough to make the work longer. Based on that
finding, improve the NAME skill in its source repository. Commit and push the resulting changes. If the weaker model
interpreted the skill well enough, do not make a change." If `INSTRUCTION` contains multiple words, do not treat any
word as a skill name; use the full sentence as the task context for reading the session.

Get the latest unarchived top-level session from OpenCode's global database, ordered by `time_updated`; do not use
`opencode session list` for this because it filters sessions by the caller's working directory. Export that session as
raw JSON with `opencode export SESSION_ID`, read the conversation, and then apply the selected context to that
transcript. Use this skill's `bin/oc` helper when available, resolved relative to this `SKILL.md`; it queries the global
database, exports the latest session by default, and strips OpenCode's leading status line so stdout is valid JSON.
Prefer the helper over piping `opencode export` directly, because raw export can truncate through a pipe; if the helper
is unavailable, query `opencode db` directly and redirect the export to a temporary file before parsing it. Do not use
`--sanitize` unless the user explicitly requests sanitized output. Do not paste the full raw export into the chat;
quote or summarize only the parts needed to answer or continue the task.

If `INSTRUCTION` is empty, summarize the latest session's goal, outcome, failures, and concrete follow-up actions.

### `:todo [TEXT|edit|path]`, `:to [TEXT|edit|path]`

Use the shared repository queue at root `TODO.md`. With text, append it as an unchecked item under `Inbox`. With no
input, print the TODO contents with numbered checklist items. With `edit`/`--edit`, open the file in the default
editor. With `path`/`--path`, print the file path. Use this skill's `bin/todo` helper when available, resolved relative
to this `SKILL.md`, not from the target repository root. Appending or editing may create a missing `TODO.md`; listing,
help, path lookup, and completion must not create one as a side effect.

### `:ok [TODO_NUMBER]`

Remove the numbered shared TODO checklist item from root `TODO.md` after it has been completed or deliberately
resolved. If no number is provided, list the TODO items and ask for a number before editing. TODO numbers are transient
display numbers; if the number is stale, invalid, or ambiguous, list the TODO again before acting. If the queue does not
exist, report that fact without creating it.

### `:do [TODO_NUMBER]`

Work on the numbered shared TODO item now. Restate the selected item briefly, treat it as the current task, and do not
mark it done unless the user explicitly asks for `:ok NUMBER` or otherwise clearly asks to close it. If the selected
work is broad, risky, multi-file, multi-step, likely to span sessions, or needs reviewable decisions, create or update a
bounded `.agents/state/tasks/` task before implementation and promote durable conclusions into `.agents/specs/`.

### `:learn [ERROR_DESCRIPTION]`, `:le [ERROR_DESCRIPTION]`

Analyze the mistake or recurring pattern and propose a harness improvement without editing files immediately. Decide
whether the prevention belongs in an existing skill, a new skill, repo-local instructions/specs/tests/state, or
user-level instructions. Answer with diagnosis, chosen location, proposed high-level change, and a confirmation question.

### `:close [push|no-push]`, `:cl [push|no-push]`

Perform repository closeout: inspect status, check root instructions and `.agents/` consistency when relevant, summarize
validation and remaining risk, and commit/push only if closeout produced tracked changes or the input explicitly
requested pushing an already-ahead branch.
