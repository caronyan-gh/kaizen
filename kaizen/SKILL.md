---
name: kaizen
description: Review the current work or environment for practical improvements — friction encountered in your own recent work, current problems and blockers, whether the needed database is available, and routine tasks worth scripting — rank each item A/B/C/Z, report them as numbered tables, and record what was approved, done, or declined so later runs do not re-propose it. Use only when the user says just "kaizen" or "改善" on its own, as a command to run this review — not when either word appears inside an ordinary request ("kaizen this module", "apply kaizen to this code", "この関数を改善して").
---

# Kaizen Skill

## Trigger

Activate this skill when the user says one of these on its own, as a command to run this review:

- `kaizen`
- `改善`

Do not activate it when the word only appears inside an ordinary request to improve something ("kaizen this module",
"apply kaizen to this code", "この関数を改善して"); handle those as normal requests.

## Purpose

Review the current work or environment for practical improvements.

## Scope

Keep the run small.

- Look only at friction from work you actually did recently. Do not turn kaizen into an audit of the whole project.
- Stop investigating once you have enough to rank an item. Root causes, fixes, and finding an owner belong to the
  approved work, not to the review.
- When the user picks items, do only those and record them. Do not run the whole kaizen again.

## Instructions

When this skill is activated, perform the following steps:

0. Recall the records of previous kaizen runs with one lookup, and do not search anywhere else:

   - The project uses `sqlite-named-query`: if it has no `kaizen_recall` query yet, create the kaizen table first
     (see "Setting up the kaizen table" below). Then run `kaizen_recall` once; it returns every owner's items.

   - The project does not use `sqlite-named-query`: read the single agent-memory entry named `kaizen`.

   - Nothing found means there is no previous run; continue.

   Use them in steps 1–5: skip what was already done, and do not re-propose a declined item unless the situation has
   changed; say what changed if you do.

   Items still `open`, `approved`, or `delegated` from earlier runs: decide from their records plus any new evidence
   from this run (mark them `done` or `declined`, or re-rank them with `kaizen_set` and `rank`). If there is no new
   evidence, keep them as they are and say "no change seen"; do not investigate them again. Declined items older than
   30 days no longer come back from `kaizen_recall`; they may be proposed again if the situation has changed.

1. Review your own recent work and identify concrete friction you encountered.

   Do not answer this by making a vague judgment such as "there were no problems".

   Examine your actual recent work using concrete questions such as:

   - Which recent task took the most time?
   - What caused the most rework, retries, or backtracking?
   - What information was missing from the instructions?
   - What did you have to infer or decide on your own?
   - What existing code, documents, tools, or project state was hardest to understand?
   - What repetitive work did you perform manually?
   - What check, script, helper, document, or project rule would have made your work easier?
   - Did you encounter the same friction more than once?
   - Did the user or another agent point out or correct something in your work? (some of your own mistakes are
     invisible to you)
   - Did you promise to "be careful" or "make sure" to do something? If the same slip happened more than once, or only
     someone else noticed it, could a script or a query enforce it instead? (for example, fold a status check and
     setting a flag into the query that reads the task) A one-off slip does not need a script.

   Prefer concrete examples from work you actually performed over general opinions.

   Do not invent problems merely to produce feedback.

   If no meaningful friction was found, this step may be empty.

2. Identify and organize any current problems, difficulties, inconveniences, or blockers not already captured in step 1.

3. If the `sqlite-named-query` skill is installed, look back at how your recent work used the database, or could have
   used it. Ask yourself:

   - Is a table missing? (something you wanted to record but had no place for)
   - Is an existing table missing a column?
   - Is there a table you want to change? (split, merge, fix a constraint or a name)
   - What did you count, compare, or piece together by hand more than once?
   - What did you search for with `nq.py list <word>` and not find? (`nq.py stats` lists searches that found nothing)
   - Did you write your own SQL, or read files, for something an existing query already answers?
   - What did you re-read from text files to check the current state?
   - Do you have improvement ideas for sqlite-named-query itself? (changes or additions to `nq.py`, how SKILL.md is
     written)
   - Was any query noticeably slow? (check `nq.py stats` rather than memory; an index or a rewrite of the query may
     help)
   - Is the database available and up to date (`nq.py status`: no pending migrations)?

   Ideas for sqlite-named-query itself: it is a shared skill used by other projects, so do not change it on the spot;
   report them to the user as proposals.

   If the project does not use sqlite-named-query yet: did you re-read or reconstruct state that a database would have
   kept?

   If the skill is not installed, skip this step and write `3.` with "not applicable" in the user's language.

4. Identify and organize any repetitive, routine, or standardized tasks that could reasonably be automated with scripts.

5. Review the items identified in steps 1–4 and rank each item with exactly one of these ranks:

   | Rank | Meaning |
   | ---- | ------- |
   | A | Necessary. Should be done now. |
   | B | Useful. Worth doing, but not urgent. |
   | C | Optional. Keep watching, or only check. |
   | Z | Unnecessary. Do not do it. |

   - Use only A, B, C and Z. Do not invent other ranks or labels.
   - If an item is fine as it is (for example, the database is available), rank it Z and say so.

6. Report the results to the user.

   - Keep steps 1, 2, 3, and 4 as separate sections.

   - Use one numbered table for each step, with the columns `#`, `Rank`, `Item`, and `Reason`.

   - Number the rows numerically from `1` in every table. Never use letters as row numbers.

   - Sort the rows by rank: all A rows first, then B, then C, then Z.

   - Write the rank as the bare letter; put the explanation in `Reason`.

   - When referring to an item (in the report or when asking the user to choose), use `<step>-<row>` such as `4-1`.
     Never use the rank letter to identify an item.

   - If a step has no items, write `<step number>.` followed by "none" in the user's language
     (for example `1. なし`) without creating a table.

   - Write the report in the user's language.

   - Report every item identified before the review, including those ranked Z.

   - Keep the report practical and concise.

7. Record the items so a later session does not rediscover or re-propose them, in two moments:

   - When you report: record every reported item right away, whether or not the user answers. Items ranked A/B/C
     start as `open`; items ranked Z are recorded as `declined` with the one-line reason (with `sqlite-named-query`,
     `kaizen_add` does this by itself from the item's `reason`).

   - When something is decided or finished: carry out the items the user approves, then update each item —
     `done` with what was done, `declined` with a one-line reason (items the user turned down), or `delegated`.
     An item ranked Z is never `done`.

   - Where to record (the same place step 0 reads): with `sqlite-named-query`, `kaizen_add` when you report
     (owner = your role) and `kaizen_set` when a decision or result changes. Without it, update the single
     agent-memory entry named `kaizen`.

## Setting up the kaizen table

Templates are in `references/sqlite/` next to this file. In a project that uses `sqlite-named-query`:

1. Copy `migration_kaizen.sql` into the project's `db/migrations/` with the next free number
   (e.g. `024_kaizen.sql`). Never edit an applied migration.

2. Copy `migration_kaizen_guards.sql` into `db/migrations/` with the number after it. It makes the database
   refuse a rank Z item marked `done` and a `declined` item without a reason. A project that already has the
   kaizen table adds just this file, with its next free number; existing rows are not touched.

3. Copy `kaizen_add.sql`, `kaizen_recall.sql` and `kaizen_set.sql` into `db/queries/`.

4. Run `nq.py migrate` and `nq.py check`. Commit these files with the project's normal procedure.

## Example

| # | Rank | Item | Reason |
| - | ---- | ---- | ------ |
| 1 | A | xxxxxx | ... |
| 2 | A | xxxxxx | ... |
| 3 | B | xxxxxx | ... |
| 4 | C | xxxxxx | ... |
| 5 | Z | xxxxxx | ... |
