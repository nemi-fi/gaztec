#!/usr/bin/env bash
set -euo pipefail

source $(dirname -- "${BASH_SOURCE[0]}")/../gaztec --version

echo "Test passed"
