# AGENTS.md

Rules for working in this repository.

## Prefer canonical documentation over inference

Read the tool's own documentation before writing config for it,
or before proposing any solution that involves it,
and read the relevant page in full.
Targeted queries return summaries,
and summaries are where wrong claims come from.

Local testing confirms behaviour on this machine.
It does not establish intent, supported syntax,
or what happens on any other machine.
Use it to verify what the documentation says, not to replace reading it.

Never truncate output you are reasoning about.
Piping a dry run through `tail` has already hidden two real bugs here.

When something cannot be verified, state it as unverified.
An assumption labelled as an assumption is fine.
An assumption stated as fact is not.

## No tool is adopted before its configuration reference is read

Read the tool's configuration reference in full before proposing it,
and before reporting anything about what it can or cannot do.
Running a tool on a fixture establishes what it does by default on that input.
It establishes nothing about what the tool can be configured to do.

Prefer tokens spent on the authoritative source over tokens spent on local trial
and error.
An experiment is for confirming what the reference already said.

A behaviour observed without reading the reference is a guess wearing the
costume of a finding, and it is worse than an admitted guess because it reads as
settled.
Two formatters described here
as fundamentally incompatible were two settings apart.

## When the tool objects, re-read its documentation first

A failed check or a warning is a diagnosis, not an obstacle.
Before proposing any change,
re-read the page defining the mechanism that objected —
having read it earlier in the session does not count.
The usual answer is that the tool is being used against its own stated model.

Never revive a rejected option without first saying what new information changed
it.

## Never attribute a pattern to a tool that did not define it

Saying "X supports this" or "this is the blessed pattern for X" is a citation.
Open X's documentation and point at where, or do not make the claim.
Write it as "a common convention" when that is what it is —
conventions are fine, borrowed authority is not.

A fabricated citation is worse than an unverified guess,
because it reads as though it came from the docs and
so deflects the scrutiny a guess would attract.

## Never restate a default

Check the default before writing a setting.
If the value matches, delete the line.
A config file should contain only deviations,
so that every line in it carries information.

## Comment only where it earns the line

Write a comment when something would otherwise be re-derived or re-litigated:
non-obvious ordering, a deliberate rule violation,
a constraint invisible from the code itself.
Never restate what the line already says.

Style is capitalised, no terminal punctuation, one line where possible.

Prefix anything pending with `TODO:`.

## A comment is read by someone who was not there

Write for a reader who arrives cold
and has none of the context the decision was made in.
State the constraint, not its history.

That rules out naming a tool the repo has since dropped,
pointing at an earlier revision of a file,
and referring to work planned elsewhere as though the reader knows the plan.
It also rules out a comment that was true when written
and quietly stopped being true.

If a comment only lands for someone who watched the decision being made,
it is a note to yourself and does not belong in the file.
