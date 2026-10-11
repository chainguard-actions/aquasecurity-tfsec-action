#!/bin/bash

set -xe

TFSEC_VERSION="latest"
if [ "$INPUT_VERSION" != "latest" ]; then
  TFSEC_VERSION="tags/${INPUT_VERSION}"
fi

wget -O - -q "$(wget -q "https://api.github.com/repos/aquasecurity/tfsec/releases/${TFSEC_VERSION}" -O - | grep -o -E "https://.+?tfsec-linux-amd64" | head -n1)" > tfsec
install tfsec /usr/local/bin/

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

if [ -n "${INPUT_ADDITIONAL_ARGS}" ]; then
  TFSEC_ARGS_OPTION="${INPUT_ADDITIONAL_ARGS}"
fi

if [ -n "${INPUT_SOFT_FAIL}" ]; then 
  SOFT_FAIL="--soft-fail"
fi

FORMAT=${INPUT_FORMAT:-default}

tfsec_args=()
if [ -n "${TFSEC_ARGS_OPTION}" ]; then
  while IFS= read -r -d '' t; do tfsec_args+=("$t"); done \
    < <(printf '%s' "${TFSEC_ARGS_OPTION}" | xargs printf '%s\0')
fi

tfsec --format="${FORMAT}" ${SOFT_FAIL:+"$SOFT_FAIL"} "${tfsec_args[@]}" "${INPUT_WORKING_DIRECTORY}"
