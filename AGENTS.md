# AGENTS.md

Rules for working in this repository.

## Review

- Audit every file you read in full against applicable rules; do not assume
  existing work is compliant
- Fix in-scope violations; report those outside the task's scope

## Research

- Before proposing a tool-based solution, configuring a tool, or describing its
  capabilities, read the relevant canonical documentation or configuration
  reference in full; summaries are insufficient
- Prefer canonical references and upstream baselines over ad hoc choices. Before
  adding ignore rules, check
  [github/gitignore](https://github.com/github/gitignore) for a matching
  baseline.
- Prefer the documented solution; invent one only as a last resort after
  checking authoritative guidance and explaining why documented paths do not
  fit; disclose it as a custom proposal, not a documented solution
- Cite documentation for claims of tool support or recommendations; distinguish
  community conventions from official guidance
- Use experiments only to confirm documentation; results establish behavior for
  the tested machine, input, and defaults, not intent, supported configuration,
  or portability
- Never truncate evidence used in reasoning; label assumptions and unverified
  claims
- Reuse documentation already available in context; re-read only when relevant
  details are missing or may have changed
- Reconsider a rejected option only after explaining what new information
  warrants it

## Implementation

- Prefer the simplest solution; add complexity only for a demonstrated design
  need
- Do not add defensive handling for hypothetical failures; complete documented
  setup proactively
- Present design options and tradeoffs, then wait for explicit approval to
  implement. Positive feedback and refinements to a proposal are not
  implementation approval. Once approved, proceed within the agreed scope
  without repeat approval.

## Configuration

- Never restate defaults; explain when no configuration changes are warranted
- For added or relocated configuration, assess deployment and mise history
  tracking separately against README.md's policy; explain any omission

## Comments

- Comment only non-obvious ordering, deliberate rule violations, or constraints
  likely to be re-derived or re-litigated. Section headings that mark where a
  part of a long file begins are also fine
- Make comments self-contained and current; omit code restatements, history,
  removed tools, old revisions, and unstated plans. A code restatement explains
  one line to someone who can already read it; a heading that labels a section
  is not one
- Keep comments short, preferably one line, without terminal punctuation
- Capitalise comments, but preserve canonical spelling and case for names and
  identifiers, even at sentence starts (for example, mise and fish)
- Use established codetags where appropriate; consult references such as
  [PEP 350's mnemonic list](https://peps.python.org/pep-0350/#mnemonics).
  Examples include `NOTE:`, `TODO:`, and `FIXME:`, but are not exhaustive.
- Align codetag continuation lines with the content after the tag

## Using hk from a coding agent

Inspect and plan before running. Scope checks to changed files with
`--files0-from` and use `--cd` to select the project root. Prefer `--safe`,
inspect command effects, and require approval for unknown or destructive
commands. Consume JSON or JSONL diagnostics while retaining raw output, and
always review the diff produced by a fix. MCP clients should use
`inspect_project`, `plan`, safe run tools, paged output, and `get_diff` rather
than invoking arbitrary shell commands.
