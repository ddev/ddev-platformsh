#!/usr/bin/env bats

# see setup.sh for instructions
setup() {
  load setup.sh
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
}

teardown() {
  load teardown.sh
}

# mariadb is called mysql in platform.sh
@test "mysql" {
  template="mysql"
  load per_test.sh
  for source in $PROJECT_SOURCE; do
    rm -rf ${TESTDIR} && mkdir -p ${TESTDIR}
    cp -r $PROJECT_SOURCE/tests/testdata/${template}/. ${TESTDIR}
    pushd ${TESTDIR} >/dev/null
    ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
    echo "# doing ddev config --project-name=${PROJNAME}" >&3
    ddev config --project-name=${PROJNAME} >/dev/null
    echo "# doing ddev add-on get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
    printf "x\nx\nx\n" | ddev add-on get $source
    ddev start -y >/dev/null
    DDEV_DEBUG="" ddev describe -j >/tmp/describe.json
    run ddev exec -s db 'echo ${DDEV_DATABASE}' >/dev/null
    assert_output "mariadb:10.5"
    ddev exec 'echo $PLATFORM_RELATIONSHIPS | base64 -d' >relationships.json 2>/dev/null

    echo "# PLATFORM_RELATIONSHIPS=$(cat relationships.json)" >&3

    assert_equal "$(jq -r .database[0].type <relationships.json)" "mariadb:10.5"
    assert_equal "$(jq -r .database[0].username <relationships.json)" "db"
    assert_equal "$(jq -r .database[0].password <relationships.json)" "db"

    popd >/dev/null
    per_test_teardown
  done
}
