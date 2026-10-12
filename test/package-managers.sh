#!/usr/bin/env bash
set -euo pipefail

# Every package manager exposes bins differently (npm symlinks them, pnpm writes shell
# shims, Yarn Berry runs them through `node` from a zip archive unless unplugged), so pack
# gaztec and run it through each of them. A fake Aztec install keeps this fast and offline
# apart from the package managers themselves.

TEST_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

VERSION=0.0.0-gaztec-test
export HOME="$WORK/home"
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
# keep the real user's npm config (registry, auth, proxy) despite the fake HOME
export NPM_CONFIG_USERCONFIG="${NPM_CONFIG_USERCONFIG:-$(npm config get userconfig)}"

mkdir -p "$HOME/.aztec/bin" "$HOME/.aztec/versions/$VERSION/bin"
printf '#!/bin/sh\n' >"$HOME/.aztec/bin/aztec-up"
printf '#!/bin/sh\necho "aztec($#) $*"\n[ "$1" = fail ] && exit "$2"\nexit 0\n' >"$HOME/.aztec/versions/$VERSION/bin/aztec"
printf '#!/bin/sh\necho "nargo $*"\n' >"$HOME/.aztec/versions/$VERSION/bin/aztec-nargo"
printf '#!/bin/sh\n' >"$HOME/.aztec/versions/$VERSION/bin/aztec-bb"
chmod +x "$HOME/.aztec/bin/aztec-up" "$HOME/.aztec/versions/$VERSION/bin/"*

(cd "$TEST_DIR/.." && npm pack --pack-destination "$WORK" >/dev/null 2>&1)
TARBALL=$(ls "$WORK"/gaztec-*.tgz)

function new_project {
  local dir="$WORK/project-$1"
  mkdir -p "$dir"
  echo "$VERSION" >"$dir/.aztecrc"
  echo "{\"name\":\"project\",\"version\":\"1.0.0\"${2:-}}" >"$dir/package.json"
  echo "$dir"
}

function expect_output {
  local name="$1" expected="$2"
  shift 2
  local actual
  actual=$("$@" 2>&1 | tail -n 1) || true
  if [[ "$actual" != "$expected" ]]; then
    echo "[$name] expected '$expected', got '$actual'" >&2
    exit 1
  fi
}

# Runs gaztec via the given command and checks args, the nargo subcommand and exit codes.
function check {
  local name="$1"
  shift
  expect_output "$name" "aztec(1) --version" "$@" --version
  expect_output "$name" "aztec(3) compile --flag with space" "$@" compile --flag "with space"
  expect_output "$name" "nargo check" "$@" nargo check
  local code=0
  "$@" fail 7 >/dev/null 2>&1 || code=$?
  if [[ "$code" != 7 ]]; then
    echo "[$name] expected exit code 7, got $code" >&2
    exit 1
  fi
  echo "ok: $name"
}

cd "$(new_project npm)"
npm install -D "$TARBALL" >/dev/null 2>&1
check "npx" npx gaztec

cd "$(new_project pnpm)"
pnpm add -D "$TARBALL" >/dev/null 2>&1
check "pnpm" pnpm gaztec
check "pnpm dlx" pnpm dlx "$TARBALL"

cd "$(new_project yarn-berry ',"packageManager":"yarn@4.9.2"')"
corepack yarn add -D "gaztec@file:$TARBALL" >/dev/null 2>&1
check "yarn berry" corepack yarn gaztec

echo "Package manager tests passed"
