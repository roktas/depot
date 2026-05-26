---
name: colon
description: Use when the user message starts with `:` to interpret prompt shortcuts such as `:commit`, `:co`, `:push`, `:pu`, `:ship`, `:sh`, `:harness`, `:ha`, `:todo TEXT`, `:to TEXT`, `:todo! TEXT`, `:to! TEXT`, `:ok NUMBER`, `:do NUMBER`, `:learn TEXT`, `:le TEXT`, `:close`, or `:cl`.
---

# Colon Shortcuts

Use this skill only for explicit prompt shortcuts at the beginning of a user message. The first token selects the
shortcut; the rest of the message is shortcut input.

Do not treat incidental `:` characters inside normal prose as shortcuts.

## Shortcuts

Every shortcut also accepts its two-character form, using the first two letters after `:`. The only exception is
`:todo!`, whose short form is `:to!`.

- `:commit [MESSAGE_HINT]`, `:co [MESSAGE_HINT]`
- `:push [REMOTE] [BRANCH]`, `:pu [REMOTE] [BRANCH]`
- `:ship [MESSAGE_HINT]`, `:sh [MESSAGE_HINT]`
- `:harness [TARGET...]`, `:ha [TARGET...]`
- `:todo [TEXT|edit|path]`, `:to [TEXT|edit|path]`
- `:todo! [TEXT|edit|path]`, `:to! [TEXT|edit|path]`
- `:ok [TODO_NUMBER]`
- `:do [TODO_NUMBER]`
- `:learn ERROR_DESCRIPTION`, `:le ERROR_DESCRIPTION`
- `:close [push|no-push]`, `:cl [push|no-push]`

## Commit

`:commit [MESSAGE_HINT]` stages relevant current changes and creates a Conventional Commit using the `commits`
rules. Do not push.

If `MESSAGE_HINT` is present, treat it as user guidance for the commit message, not as a mandatory literal message.
Inspect the diff first and keep the final commit message accurate.

## Push

`:push [REMOTE] [BRANCH]` pushes the current branch. Do not create a commit unless explicitly requested.

Defaults:

- `REMOTE`: use the configured upstream remote.
- `BRANCH`: use the current branch.

If push fails because local and remote history diverged, do not force push unless the user explicitly asked for it or the
conversation has already established that the local branch is authoritative.

## Ship

`:ship [MESSAGE_HINT]` runs `:commit [MESSAGE_HINT]` and then `:push`.

If there are no tracked or untracked changes to commit, skip the commit step and only push when the branch is ahead of
its upstream.

## Harness

`:harness [TARGET...]` runs the repository's relevant harness or consistency checks. In this repo, use the validation
commands in `AGENTS.md` and the active task/spec context.

Argument hints:

- No argument: run the normal relevant checks for the current changes.
- `provision`: run provisioning plan/smoke/RuboCop/shellcheck checks as applicable.
- `shell`: run shell syntax and shellcheck checks.
- `quick`: run the smallest useful check set.

Treat unknown harness arguments as user intent and choose the closest relevant check set; explain the mapping briefly.

## TODO

`:todo [TEXT|edit|path]` targets the shared `.agents/notes/todo.md` inbox.

- `:todo TEXT`: append `TEXT`.
- `:todo edit` or `:todo --edit`: open the shared TODO in the default editor.
- `:todo path` or `:todo --path`: print the shared TODO path.
- `:todo` with no argument: print the shared TODO contents with numbered checklist items.

`:todo! [TEXT|edit|path]` is a compatibility alias for the same shared TODO. Do not create a separate agent-owned TODO
for ordinary repository work.

When the user refers to a listed TODO number, interpret it as the numbered checklist item from the latest relevant
`:todo` or `:todo!` listing. If the reference is stale or ambiguous, list the TODO again before acting. Use the target
file path plus the checklist text, not the transient number, when promoting or editing durable task notes.

## OK

`:ok [TODO_NUMBER]` marks a shared TODO checklist item as done.

- `:ok 2`: mark shared TODO item 2 as `- [x]`.
- `:ok` with no argument: list shared TODO items, ask the user for a number, then mark that item as done.

## Do

`:do [TODO_NUMBER]` directs the agent to work on the numbered shared TODO item now. It accepts the same number argument
as `:ok`, but it does not mark the item complete by itself.

- `:do 2`: resolve shared TODO item 2, restate the selected item briefly, then treat that item as the current user task.
- `:do` with no argument: list shared TODO items and ask the user for a number before starting work.
- If the number is stale, invalid, or points at an already completed item, list the TODO and ask for a corrected number.
- Do not write an in-progress state to `.agents/notes/todo.md`; active work lives in the current conversation.
- After completing the work, mark the item done only when the user explicitly asks for `:ok NUMBER` or otherwise clearly
  asks to close that item.
- Trivial one-turn work can stay only in the conversation. If the selected item is broad, risky, multi-file,
  multi-step, likely to span sessions, or likely to need reviewable decisions, create or update a bounded
  `.agents/tasks/` task before implementation and use that task for planning, history, validation, and handoff notes.

TODO numbers are transient display numbers from the current file contents. If the user gives a stale or invalid number,
list the TODO again and ask for a corrected number.

## Learn

`:learn [ERROR_DESCRIPTION]` or `:le [ERROR_DESCRIPTION]` proposes harness improvements. Do not edit files immediately.

With an argument, analyze a specific mistake using this prompt frame:

```text
Your mistake is: ERROR_DESCRIPTION.
Carefully analyze why this mistake happened and what should change so you do not repeat it.
```

Without an argument, use this prompt frame:

```text
Considering this session's requests, the user's style, and the mistakes made so far, are there harness changes that
would be useful in the future?
```

Then decide where the prevention belongs:

- Existing skill: choose this when a specific workflow, language, tool, or domain skill caused or can prevent the
  mistake.
- New skill: choose this when the mistake reveals a recurring workflow that is not covered by an existing skill and is
  specific enough to trigger reliably.
- Repo-wise harness: choose this when the prevention is project-specific and belongs in root instructions, repo-local
  specs, repo-local skills, tests, or task notes.
- User-wise harness: choose this when the prevention is broad across repositories and belongs in user-level instructions
  such as the global `AGENTS.md`.

Answer with:

1. A short diagnosis of the mistake or recurring pattern.
2. The chosen prevention location and why alternatives are weaker.
3. The exact proposed change at a high level.
4. A confirmation question before making any edits.

## Close

`:close [push|no-push]` performs the `agents` closeout routine: check root instructions and `.agents/` consistency,
update useful state or task notes, refresh the checkpoint, and commit/push only if closeout produced tracked changes.

Defaults:

- Push closeout commits when a tracked closeout change was committed.
- Use `:close no-push` to commit without pushing.
- Use `:close push` to push after committing, and to push an already-ahead branch even when no new closeout commit was
  needed.

## TODO File

Use `.agents/notes/todo.md` for the shared repository TODO inbox. It is tracked and editable by humans and agents, but
it is still not canonical project truth. Promote useful items into `.agents/tasks/<task>/todo.md` or `.agents/specs/`
when they become tracked work or durable behavior.

## TODO Helper

Use this skill's helper, resolved relative to the directory that contains this `SKILL.md`. Do not look for `bin/todo`
in the target repository root.

```bash
./bin/todo shared "Revisit Linux package baseline"
./bin/todo human "Compatibility alias for the shared TODO"
./bin/todo shared --edit
./bin/todo shared --ok 2
./bin/todo agent --path
```
