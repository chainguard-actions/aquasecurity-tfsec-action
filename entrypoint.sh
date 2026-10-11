#!/bin/bash

set -x

TFSEC_VERSION="latest"
if [ "$INPUT_VERSION" != "latest" ]; then
  TFSEC_VERSION="tags/${INPUT_TFSEC_VERSION}"
fi

wget -O - -q "$(wget -q "https://api.github.com/repos/aquasecurity/tfsec/releases/${TFSEC_VERSION}" -O - | grep -o -E "https://.+?tfsec-linux-amd64" | head -n1)" > tfsec
install tfsec /usr/local/bin/

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

tfsec_args=()
if [ -n "${INPUT_ADDITIONAL_ARGS}" ]; then
  while IFS= read -r -d '' t; do tfsec_args+=("$t"); done \
    < <(printf '%s' "${INPUT_ADDITIONAL_ARGS}" | xargs printf '%s\0')
fi

if [ -n "${INPUT_SOFT_FAIL}" ]; then 
  SOFT_FAIL="--soft-fail"
fi

FORMAT=${INPUT_FORMAT:-default}

tfsec --format="${FORMAT}" ${SOFT_FAIL:+"${SOFT_FAIL}"} "${tfsec_args[@]}" "${INPUT_WORKING_DIRECTORY}"
