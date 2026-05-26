# Agents Skill Review

## Brief

Review `agents/skills/agents/SKILL.md` as a pragmatic repo-local workspace skill. The goal is to keep the skill useful
as a guide for `.agents/` layout and lightweight workflow, without making it verbose, brittle, or likely to conflict
with future agent platform behavior.

## Current Assessment

The core direction is sound. The skill gives agents a simple mental model for where agent-facing artifacts belong:
`notes/` for shared drafts and inboxes, `specs/` for durable truth, `tasks/` for bounded work, `tests/` for
agent-facing validation, and `state/` for local runtime residue.

The main issue is not correctness; it is layering. `SKILL.md` currently acts both as the trigger-time decision guide and
as the detailed policy manual. It also duplicates much of `references/layout.md`. That costs context on every trigger
and makes the skill more likely to become stale when agent runtimes gain native session, task, TODO, or memory features.

## Recommendations

1. Keep `SKILL.md` as the small router.

   The body should contain only the rules an agent usually needs immediately: the directory map, placement decision
   order, a few hard boundaries, the task creation threshold, and a short consistency pass. Detailed examples and
   templates should live in references.

2. Remove duplication between `SKILL.md` and `references/layout.md`.

   Keep one short directory table in `SKILL.md`. Put expanded examples, canonical trees, task templates, and edge cases
   in `references/layout.md`. The current reference is useful, but the skill body repeats enough of it that progressive
   disclosure is weaker than it should be.

3. Preserve the notes/tasks/specs promotion model.

   This is the strongest part of the skill and should remain prominent:

   - `notes/` is an inbox and draft area.
   - `tasks/` is for bounded execution history and handoff.
   - `specs/` is canonical project truth.
   - `state/` is untracked runtime residue.

4. Keep task creation conditional.

   The skill should continue to avoid creating task directories for trivial one-turn work. A good threshold is:
   create `.agents/tasks/` only when the work is broad, risky, multi-file, likely to span sessions, or likely to need
   reviewable decisions. This keeps the workflow pragmatic.

5. Soften future-sensitive session workflow.

   Session checkpoints and closeout are useful repo conventions, but they should not read like universal agent
   behavior. Phrase them as repo-local conventions to follow when present and practical. Root `AGENTS.md`, specs, and
   future platform behavior should be allowed to supersede the skill's generic workflow guidance.

6. Reduce prompt-shortcut coupling.

   The skill should not list individual `:todo`, `:ship`, or closeout shortcuts. It is enough to say that prompt
   shortcuts belong to the focused `colon` skill. This avoids drift as shortcut semantics change.

7. Keep helper layout guidance, but avoid over-prescribing implementation.

   The `bin/`, `scripts/`, and optional `lib/` guidance is useful. Keep it short and principle-based:
   executable command surfaces go in `bin/`; support implementation goes in `scripts/`; shared code gets `lib/` only
   after duplication or complexity justifies it.

8. Add an explicit precedence rule.

   The skill should say that more specific repository instructions, specs, and task notes win over this generic layout
   guidance. This makes the skill less likely to block future conventions.

9. Keep the consistency pass short.

   The current consistency pass is useful, but it can be compressed. It should check only for the common failures:
   specs as durable truth, tasks not contradicting specs, TODOs reflecting reality, tests matching contracts, and state
   remaining local.

10. Target a smaller `SKILL.md`.

   A reasonable target is roughly 100-140 lines for `SKILL.md`, with `references/layout.md` holding the examples. The
   current token use is not bad, but trimming would make the skill safer to trigger frequently.

## Suggested Shape

Use this rough structure if the skill is revised:

1. Purpose
2. Directory map
3. Placement decision order
4. Minimal workflows
5. Naming and helper conventions
6. Consistency pass
7. Reference loading guidance

Avoid putting detailed task templates, checkpoint examples, shortcut lists, or long explanatory prose in the main skill
body.

## Proposed Outcome

The skill should remain a pragmatic `.agents/` layout and workflow guide, not a second project root and not a session
manager. It should help agents place files correctly, promote durable information to the right place, and leave enough
freedom for repository-specific instructions or future platform features to take precedence.

## Implementation

Applied the review by reducing `agents/skills/agents/SKILL.md` to trigger-time guidance:

- Added an explicit precedence rule for root instructions, specs, task notes, and future platform features.
- Kept the directory map, placement order, promotion model, conditional task threshold, helper naming guidance, and short
  consistency pass.
- Removed detailed checkpoint examples, shortcut lists, long task workflow prose, and repeated directory examples from
  the main skill body.

Expanded `agents/skills/agents/references/layout.md` with the details that should remain available on demand:

- Precedence order
- Task creation threshold and handoff sections
- Skill helper layout
- Session checkpoint guidance
- Shared TODO semantics
- Repository instruction and consistency-pass details

## Validation

- `git diff --check`
- Ruby YAML frontmatter parse for `agents/skills/agents/SKILL.md`
- `python3 /home/roktas/Dropbox/var/codex/skills/.system/skill-creator/scripts/quick_validate.py agents/skills/agents`
