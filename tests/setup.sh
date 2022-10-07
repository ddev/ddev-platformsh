#!/bin/bash

bats_require_minimum_version 1.8.0
set -eu -o pipefail
export PROJECT_SOURCE="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
export TESTDIR=~/tmp/testplatformsh
export PROJNAME=test-platformsh
export DDEV_NON_INTERACTIVE=true
brew_prefix=$(brew --prefix)
docker volume rm $PROJNAME-mariadb 2>/dev/null || true
load "${brew_prefix}/lib/bats-support/load.bash"
load "${brew_prefix}/lib/bats-assert/load.bash"
