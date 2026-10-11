<!-- markdownlint-disable -->

# Hardening Report: aquasecurity--tfsec-action/v1.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **aquasecurity--tfsec-action/v1.0.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: entrypoint.sh uses unquoted shell variable expansions of variables derived from workflow-controllable inputs, allowing shell metacharacter injection. Specifically:

1. Line 26 (final tfsec command): `tfsec --format=${FORMAT} ${SOFT_FAIL} ${TFSEC_ARGS_OPTION} "${INPUT_WORKING_DIRECTORY}"` — `${FORMAT}` (from INPUT_FORMAT), `${SOFT_FAIL}` (from INPUT_SOFT_FAIL), and `${TFSEC_ARGS_OPTION}` (from INPUT_ADDITIONAL_ARGS) are all unquoted. An attacker-controlled value containing shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) in any of these inputs would be interpreted by the shell.

2. Line 10 (wget URL): `${TFSEC_VERSION}` is unquoted inside the command substitution URL, and its value is derived from `INPUT_VERSION`/`INPUT_TFSEC_VERSION`.

All these variables are sourced from action inputs that are workflow-controllable and must be double-quoted in shell expansions.

Locations:

- `entrypoint.sh:10`
- `entrypoint.sh:26`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed entrypoint.sh:
1. Line 10: Quoted ${TFSEC_VERSION} inside the wget URL string to prevent injection from INPUT_VERSION/INPUT_TFSEC_VERSION.
2. Line 26 (tfsec command): Quoted ${FORMAT} as "${FORMAT}"; used ${SOFT_FAIL:+"${SOFT_FAIL}"} for the literal flag (safe conditional expansion); replaced unquoted ${TFSEC_ARGS_OPTION} (from INPUT_ADDITIONAL_ARGS, a list input) with an xargs-tokenized bash array expanded as "${tfsec_args[@]}" to preserve argument boundaries while preventing shell metacharacter injection. Bash constructs are safe here since the Dockerfile installs bash and the shebang is #!/bin/bash.

