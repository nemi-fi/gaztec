#!/usr/bin/env bash
set -euo pipefail

source $(dirname -- "${BASH_SOURCE[0]}")/../gaztec --version

source $(dirname -- "${BASH_SOURCE[0]}")/../gaztec nargo --version

echo "Test passed"
