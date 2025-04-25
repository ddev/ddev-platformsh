#!/usr/bin/env bash

per_test_setup() {
  set -e -o pipefail
  set +u
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  rm -rf ${TESTDIR} && mkdir -p ${TESTDIR} && cd ${TESTDIR}
  curl -sfL -o /tmp/testtemplate.tgz "https://github.com/platformsh-templates/${template}/tarball/master"
  tar -zxf /tmp/testtemplate.tgz --strip-components=1
  # If the template happens to have a .ddev directory, remove as it can break things
  rm -rf .ddev
  # Start with bogus settings so we know we got the right stuff when testing
  ddev config --project-name=${PROJNAME} --php-version=5.6 --database=mariadb:10.1 --docroot=x --project-type=php --web-environment-add=PLATFORMSH_CLI_TOKEN=notokenrightnow,PLATFORM_PROJECT=notyet,PLATFORM_ENVIRONMENT=notyet
  echo "# doing ddev add-on get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  run ddev add-on get ${PROJECT_SOURCE}
  assert_success

  if [ -f ${PROJECT_SOURCE}/tests/testdata/${template}/db.sql.gz ]; then
    run ddev import-db --file=${PROJECT_SOURCE}/tests/testdata/${template}/db.sql.gz
    assert_success
  fi

  echo "# doing ddev restart with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  run ddev restart
  assert_success
}

per_test_teardown() {
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
}
