#!/usr/bin/env bash

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests
# Or run individual test file with:
#   bats ./tests/php.bats
# To exclude release tests:
#   bats ./tests --filter-tags '!release'
# For debugging:
#   bats ./tests --show-output-of-passing-tests --verbose-run --print-output-on-failure

bats_require_minimum_version 1.8.0
set -eu -o pipefail
export PROJECT_SOURCE="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
export TESTDIR=~/tmp/test-platformsh
export PROJNAME=test-platformsh
export DDEV_NONINTERACTIVE=true
export DDEV_NO_INSTRUMENTATION=true
docker volume rm $PROJNAME-mariadb 2>/dev/null || true
TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
export BATS_LIB_PATH="${BATS_LIB_PATH}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"
bats_load_library bats-assert
bats_load_library bats-file
bats_load_library bats-support
