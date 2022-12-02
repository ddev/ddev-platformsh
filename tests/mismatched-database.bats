# Requires bats-assert and bats-support
# brew tap kaos/shell &&
# brew install bats-core bats-assert bats-support jq mkcert yq
setup() {
  load setup.sh
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
}

teardown() {
  load teardown.sh
}

@test "mismatched-database" {
  template="mismatched-database"
  load per_test.sh
  for source in $PROJECT_SOURCE; do
    rm -rf ${TESTDIR} && mkdir -p ${TESTDIR}
    cp -r $PROJECT_SOURCE/tests/testdata/${template}/. ${TESTDIR}
    pushd ${TESTDIR} >/dev/null
    ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
    echo "# doing ddev config --project-name=${PROJNAME}" >&3
    ddev config --project-name=${PROJNAME} --database=mariadb:10.2 >/dev/null
    ddev start -y >/dev/null
    echo "# doing ddev get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
    printf 'x\nx\nx\n' | (ddev get $source 2>&1 || true) | grep "There is an existing database in this project"
    popd >/dev/null

    per_test_teardown
  done
}
