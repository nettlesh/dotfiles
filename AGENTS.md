# AGENTS.md

Rules for working in this repository.

## Review

- Audit every file you read against all applicable rules,
  not just task-relevant lines
- Assume existing work may be noncompliant
- Fix in-scope violations; report others

## Research

- Before proposing a tool-based solution, configuring a tool,
  or describing its capabilities,
  read the relevant canonical documentation or configuration reference in full;
  summaries are insufficient
- Use experiments only to confirm the documentation.
  Results establish behavior only for the tested machine, input,
  and defaults—not intent, supported configuration, or portability
- Never truncate evidence used in reasoning
- Label assumptions and unverified claims
- After a warning or failure,
  re-read the documentation for that mechanism before proposing a change,
  even if already read this session
- Reconsider a rejected option only
  after stating what new information changed the decision
- Claim a tool supports or recommends a pattern only with a documentation
  citation; otherwise call it a convention

## Implementation

- Address observed problems only;
  do not add defensive handling for hypothetical failures.
  Let them surface first

## Configuration

- Add only meaningful deviations from documented defaults;
  never restate a default

## Comments

- Comment only non-obvious ordering, deliberate rule violations,
  or constraints likely to be re-derived or re-litigated
- Write for a reader with no prior context; state the current constraint,
  not its history
- Do not restate code, mention removed tools or old revisions,
  depend on unstated plans, or leave stale comments
- Capitalise comments, omit terminal punctuation, and prefer one line
- Use conventional annotations such as `NOTE:`, `TODO:`,
  and `FIXME:` when appropriate
