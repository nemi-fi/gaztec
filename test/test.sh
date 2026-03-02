#!/usr/bin/env bash
set -euo pipefail

# check if the version of aztec is the same as the version in the .aztecrc file

gaztec_version=$(source ../gaztec --version)
file_version=$(cat .aztecrc)

if [[ "$gaztec_version" != "$file_version" ]]; then
  echo "Test failed: gaztec version $gaztec_version is not the same as the version in the .aztecrc file $file_version"
  exit 1
fi

echo "Test passed"
