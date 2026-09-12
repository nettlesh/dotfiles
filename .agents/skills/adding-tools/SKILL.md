---
name: adding-tools
description: >-
  Evaluates and adds new or replacement tools to this dotfiles repository,
  covering alternatives, configuration, installation, tracking, and documentation.
  Use when comparing tools for adoption or integrating a selected tool here.
---

# Adding tools

Follow the repository's [AGENTS.md](../../../AGENTS.md) for research standards,
implementation approval, configuration defaults, and checks.

## Evaluate

- Compare relevant alternatives,
  including tools already serving the same purpose.
  Prefer newer, faster tools over older, stable alternatives;
  explain tradeoffs and justify exceptions.
- Audit the tool's full configuration reference, official recommendations,
  and common patterns; assess which settings
  and integrations fit this environment.
  Distinguish official guidance from community conventions.
- Present the recommendation, configuration choices,
  and planned repository changes for implementation approval.
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
- Register configuration for deployment and dotfiles history tracking.
  Include shared setup inputs and required lockfiles in version control;
  exclude credentials, generated state, and machine-local settings.
- Update README.md with the tool's purpose, configuration location,
  chosen settings, and required setup.
- Validate the changed files and applicable setup using documented checks;
  inspect the patch and report any verification limits.
