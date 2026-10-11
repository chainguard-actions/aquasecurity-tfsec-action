<!-- markdownlint-disable -->

# Hardening Report: aquasecurity--tfsec-action/v1.0.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **aquasecurity--tfsec-action/v1.0.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (b) violation: entrypoint.sh uses unquoted shell variable expansions of workflow-controllable input values in shell commands.

1. Line 27: `tfsec --format=${FORMAT} ${SOFT_FAIL} ${TFSEC_ARGS_OPTION} "${INPUT_WORKING_DIRECTORY}"` — `${FORMAT}` (sourced from `INPUT_FORMAT`/`inputs.format`), `${SOFT_FAIL}` (sourced from `INPUT_SOFT_FAIL`/`inputs.soft_fail`), and `${TFSEC_ARGS_OPTION}` (sourced from `INPUT_ADDITIONAL_ARGS`/`inputs.additional_args`) are all unquoted. An attacker-controlled value containing shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) will be parsed by the shell, enabling command injection.

2. Line 10: `wget -q https://api.github.com/repos/aquasecurity/tfsec/releases/${TFSEC_VERSION} -O -` — `${TFSEC_VERSION}` is derived from `INPUT_VERSION` (`inputs.version`) and is unquoted inside the URL, allowing shell metacharacter injection.

All of these variables should be double-quoted: `"${FORMAT}"`, `"${SOFT_FAIL}"`, `"${TFSEC_ARGS_OPTION}"`, `"${TFSEC_VERSION}"`.


Locations:

- `entrypoint.sh:10`
- `entrypoint.sh:27`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed entrypoint.sh:
1. Quoted ${TFSEC_VERSION} inside the wget URL on line 10: changed to "https://api.github.com/repos/aquasecurity/tfsec/releases/${TFSEC_VERSION}".
2. Quoted ${FORMAT} in the tfsec command: --format="${FORMAT}".
3. Used ${SOFT_FAIL:+"$SOFT_FAIL"} for the optional --soft-fail flag so it drops out when empty.
4. Tokenized ${TFSEC_ARGS_OPTION} (from INPUT_ADDITIONAL_ARGS, an args list) via xargs into a bash array tfsec_args, then expanded as "${tfsec_args[@]}" to preserve argument boundaries and prevent shell metacharacter injection.

