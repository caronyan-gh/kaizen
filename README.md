# kaizen

A skill (`SKILL.md` format) for AI coding agents: say **"kaizen"** and the agent reviews its own recent work and the project for practical improvements, ranks every item, and remembers what you approved or declined — so the next run picks up where the last one left off instead of suggesting the same things again.

## What a run does

1. **Your own friction** — the agent looks back at work it actually did: what took longest, what caused rework, what was missing from the instructions, what it did by hand more than once. Concrete examples only; no invented problems.
2. **Current problems** — blockers and inconveniences not already covered.
3. **Database** — if the project uses [sqlite-named-query](https://github.com/caronyan-gh/sqlite-named-query), whether the database is up to date and the needed queries exist; if not, whether keeping some state in a database would help.
4. **Automation** — repetitive tasks worth turning into scripts.

Every item gets exactly one rank:

| Rank | Meaning |
|---|---|
| A | Necessary. Do it now. |
| B | Useful, not urgent. |
| C | Optional. Keep watching. |
| Z | Unnecessary. Don't do it. |

The report is one numbered table per step, so you can answer with just the numbers:

> 1-1, 1-3 and 4-1. Skip the rest.

## It remembers

What was done, and what you declined, is recorded with a one-line reason. The next run reads those records first:

- done items are not rediscovered,
- declined items are not proposed again unless the situation changed,
- anything still open is reviewed — closed, declined, or re-ranked — instead of piling up.

Records live in the project's SQLite database when the project uses [sqlite-named-query](https://github.com/caronyan-gh/sqlite-named-query) (table and query templates are in `kaizen/references/sqlite/`; the agent sets them up on the first run). Otherwise they go to the agent's own memory.

## Install

Copy the `kaizen/` directory into the skills directory your agent reads (for example `~/.claude/skills/` or `~/.agents/skills/`; check your agent's docs):

```bash
git clone https://github.com/caronyan-gh/kaizen.git
cp -r kaizen/kaizen <your-skills-dir>/
```

Then say `kaizen` (or `改善`) in any project.

## Field note

In one real multi-agent project, the first run with the "your own friction" step found that the designer agent had rewritten one design decision four times because it wrote down a preference before asking, and had written the same replace-in-file script six times in a day. The second finding became a shared skill the same day.

<sub>*Individual results may vary.</sub>

## See also

[sqlite-named-query](https://github.com/caronyan-gh/sqlite-named-query) — the thin SQLite layer kaizen records into when a project uses it. Agents keep project state there and read it back through named queries.

## License

[MIT](LICENSE) © caronyan
