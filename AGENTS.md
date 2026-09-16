# AGENTS.md

Rules for working in this repository.

## Review

- Audit every file you read in full against applicable rules;
  do not assume existing work is compliant
- Fix in-scope violations; report those outside the task's scope

## Research

- Before proposing a tool-based solution, configuring a tool, or describing
  its capabilities, read the relevant canonical documentation or configuration
  reference in full; summaries are insufficient
- Prefer canonical references and upstream baselines over ad hoc choices.
  Before adding ignore rules,
  check [github/gitignore](https://github.com/github/gitignore)
  for a matching baseline.
- Prefer the documented solution;
  invent one only as a last resort after checking authoritative guidance
  and explaining why documented paths do not fit;
  disclose it as a custom proposal, not a documented solution
- Cite documentation for claims of tool support or recommendations;
  distinguish community conventions from official guidance
- Use experiments only to confirm documentation;
  results establish behavior for the tested machine, input, and defaults,
  not intent, supported configuration, or portability
- Never truncate evidence used in reasoning;
  label assumptions and unverified claims
- Reuse documentation already available in context;
  re-read only when relevant details are missing or may have changed
- Reconsider a rejected option only
  after explaining what new information warrants it

## Implementation

- Prefer the simplest solution;
  add complexity only for a demonstrated design need
- Do not add defensive handling for hypothetical failures;
  complete documented setup proactively
- Present design options and tradeoffs,
  then wait for explicit approval to implement.
  Positive feedback and refinements to a proposal are not implementation
  approval.
  Once approved, proceed within the agreed scope without repeat approval.

## Configuration

- Never restate defaults; explain when no configuration changes are warranted
- For added or relocated configuration, assess deployment and mise history
  tracking separately against README.md's policy; explain any omission

## Comments

- Comment only non-obvious ordering, deliberate rule violations,
  or constraints likely to be re-derived or re-litigated.
  Section headings that mark where a part of a long file begins are also fine
- Make comments self-contained and current; omit code restatements, history,
  removed tools, old revisions, and unstated plans.
  A code restatement explains one line to someone who can already read it;
  a heading that labels a section is not one
- Keep comments short, preferably one line, without terminal punctuation
- Capitalise comments, but preserve canonical spelling and case for names
  and identifiers, even at sentence starts (for example, mise and fish)
- Use established codetags where appropriate;
  consult references such
  as [PEP 350's mnemonic list](https://peps.python.org/pep-0350/#mnemonics).
  Examples include `NOTE:`, `TODO:`, and `FIXME:`, but are not exhaustive.
- Align codetag continuation lines with the content after the tag

## hk

- Ask the hk MCP server to inspect the project and plan checks before execution
- Scope work to changed files
  (`--files0-from` accepts exact NUL-delimited paths)
  and use `--cd` for another project root
- Prefer safe checks and safe fixes; inspect command effects and ask before any
  unknown or destructive command
- Read normalized diagnostics from structured results, then inspect the patch
  before reporting or committing a fix
- If MCP is unavailable, run `hk run check --format jsonl --safe`; the final
  event is the authoritative summary
