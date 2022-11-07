#!/bin/bash

per_test_setup() {
  set -e -o pipefail
  set +u
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  rm -rf ${TESTDIR} && mkdir -p ${TESTDIR} && cd ${TESTDIR}
  curl -sfL -o /tmp/testtemplate.tgz "https://github.com/platformsh-templates/${template}/tarball/master"
  tar -zxf /tmp/testtemplate.tgz --strip-components=1
  # Start with bogus settings so we know we got the right stuff when testing
  ddev config --project-name=${PROJNAME} --php-version=5.6 --database=mariadb:10.1 --docroot=x --create-docroot --project-type=php --web-environment-add=PLATFORMSH_CLI_TOKEN=notokenrightnow,PLATFORM_PROJECT=notyet,PLATFORM_ENVIRONMENT=notyet
  echo "# doing ddev get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${PROJECT_SOURCE}
  echo "# doing ddev restart with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev restart >/dev/null
}

per_test_teardown() {
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
}
