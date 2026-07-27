#!/usr/bin/env bash
set -euo pipefail

TEST_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
GAZTEC="$TEST_DIR/../gaztec"

# Aztec changed its install layout in 5.1.0: native tools moved into an internal-bin/ that
# is deliberately kept off PATH, the binaries exposed in bin/ gained an `aztec-` prefix, and
# `bin/aztec` became a wrapper around the npm bin. Both layouts have to keep working, so
# exercise a version on either side of that change. The repo's own .aztecrc pins the older
# one.
function test_version {
  local version="$1"
  local dir
  dir=$(mktemp -d)
  echo "$version" >"$dir/.aztecrc"

  echo "--- testing aztec $version ---"

  # `aztec-up use` chats on stdout too, so only the last line is the version itself
  local reported
  reported=$(cd "$dir" && source "$GAZTEC" --version | tail -n 1)
  if [[ "$reported" != "$version" ]]; then
    echo "Expected 'gaztec --version' to report $version, got '$reported'" >&2
    rm -rf "$dir"
    exit 1
  fi

  # `gaztec nargo` has to find nargo wherever the layout puts it.
  (cd "$dir" && source "$GAZTEC" nargo --version) >/dev/null

  rm -rf "$dir"
}

test_version "$(tr -d '\n' <"$TEST_DIR/../.aztecrc")"
test_version "5.1.0"

echo "Test passed"
