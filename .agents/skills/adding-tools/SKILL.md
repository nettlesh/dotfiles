---
name: adding-tools
description: >-
  Evaluate adopting or replacing tools, and integrate selected tools into this
  dotfiles repository. Excludes configuring existing tools and answering factual
  questions about them.
---

# Adding tools

Follow the repository's [AGENTS.md](../../../AGENTS.md) for research standards,
implementation approval, configuration defaults, and checks.

## Evaluate

- When asked to evaluate adoption, compare relevant alternatives,
  including tools already serving the same purpose.
  Prefer newer, faster tools over older, stable alternatives;
  explain tradeoffs and justify exceptions.
- If the user has selected a tool, proceed to integration without reopening
  the alternatives comparison.
- Identify settings and integrations needed for adoption.
  For an evaluation-only request, stop at the recommendation.

## Integrate

- Read [README.md](../../../README.md)
  and the applicable mise configuration to identify installation scopes,
  deployment mappings, history tracking, and lockfile ownership.
  Check the root `mise.toml`, relevant `mise.*.toml` layers,
  and `mise/config.toml` as applicable.
- Add the tool to the appropriate installation manifest
  and place its shared configuration in the repository's existing layout.
  Apply the approved settings and integrations.
- Assess deployment and history tracking separately under README.md's policy;
  include required lockfiles with their owning configuration.
  Report these assessments in the task response.
- Update README.md only when adoption changes information needed to understand,
  install, restore, or customize these dotfiles.
  Write for the owner maintaining the environment and readers inspecting
  or adapting it; preserve the existing structure.
  Add or update an entry in the appropriate existing tools table
  when it helps explain the dotfiles environment or source checks.
  Installing a dependency alone does not warrant a table entry or section.
  Keep prose specific to this repository's choices and required setup;
  omit generic tool tutorials, incidental maintenance tooling,
  and implementation reports.
