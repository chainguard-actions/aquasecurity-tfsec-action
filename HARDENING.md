<!-- markdownlint-disable -->

# Hardening Report: aquasecurity--tfsec-action/v1.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **aquasecurity--tfsec-action/v1.0.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In entrypoint.sh line 26, the variables `${FORMAT}`, `${SOFT_FAIL}`, and `${TFSEC_ARGS_OPTION}` are expanded unquoted in the final `tfsec` command. These variables are derived directly from workflow-controllable inputs (`INPUT_FORMAT`, `INPUT_SOFT_FAIL`, `INPUT_ADDITIONAL_ARGS` respectively), which are set by the calling workflow. An attacker can inject shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) through these inputs to achieve arbitrary command execution. The offending line is: `tfsec  --format=${FORMAT} ${SOFT_FAIL} ${TFSEC_ARGS_OPTION} "${INPUT_WORKING_DIRECTORY}"`. All three unquoted expansions should be double-quoted: `"${FORMAT}"`, `"${SOFT_FAIL}"`, `"${TFSEC_ARGS_OPTION}"`.

Locations:

- `entrypoint.sh:26`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed entrypoint.sh line 26: (1) Quoted ${FORMAT} as "${FORMAT}" to prevent word splitting/glob injection. (2) Replaced unquoted ${SOFT_FAIL} with ${SOFT_FAIL:+"${SOFT_FAIL}"} for safe optional flag expansion. (3) Replaced unquoted ${TFSEC_ARGS_OPTION} with a bash array (tfsec_extra_args) populated via xargs tokenization (with a non-empty guard) to safely handle the space-separated additional_args input while preserving argument boundaries and preventing shell metacharacter injection.

