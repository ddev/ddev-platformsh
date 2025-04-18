#!/usr/bin/env bash

set -eu -o pipefail
[ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
