<!-- markdownlint-disable -->

# Hardening Report: aquasecurity--tfsec-action/v1.0.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **aquasecurity--tfsec-action/v1.0.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (b): Unquoted shell variable expansion of untrusted data in entrypoint.sh. On line 63, `${TFSEC_ARGS_OPTION}` is expanded without double-quotes. This variable is set directly from `INPUT_ADDITIONAL_ARGS` (a user-controlled action input, line 54: `TFSEC_ARGS_OPTION="${INPUT_ADDITIONAL_ARGS}"`). Because it is unquoted in the final `tfsec` invocation, the shell performs word-splitting and glob expansion on the value, allowing an attacker who controls the `additional_args` input to inject shell metacharacters (`;`, `$(...)`, `|`, backticks, etc.) and achieve arbitrary command execution. The offending line is: `tfsec --format="${FORMAT}" ${SOFT_FAIL} ${TFSEC_ARGS_OPTION} "${INPUT_WORKING_DIRECTORY}"`. Fix: quote the expansion as `"${TFSEC_ARGS_OPTION}"`, or use an array to pass arguments safely.

Locations:

- `entrypoint.sh:63`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in entrypoint.sh: replaced unquoted `${TFSEC_ARGS_OPTION}` and `${SOFT_FAIL}` expansions with a bash array (`tfsec_args`). `INPUT_ADDITIONAL_ARGS` (an args-style list input) is now safely tokenized using the xargs/printf NUL-delimited pattern into the array, preserving argument boundaries and honoring quotes within the value. `--soft-fail` is added directly to the array when `INPUT_SOFT_FAIL` is set. The final `tfsec` invocation uses `"${tfsec_args[@]}"` for safe, properly-quoted expansion.

