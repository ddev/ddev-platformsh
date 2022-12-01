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

@test "oddrelationships" {
  template="oddrelationships"
  load per_test.sh
  for source in $PROJECT_SOURCE; do
    rm -rf ${TESTDIR} && mkdir -p ${TESTDIR}
    cp -r $PROJECT_SOURCE/tests/testdata/${template}/. ${TESTDIR}
    pushd ${TESTDIR} >/dev/null
    ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
    echo "# doing ddev config --project-name=${PROJNAME}" >&3
    ddev config --project-name=${PROJNAME} >/dev/null
    echo "# doing ddev get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
    printf "x\nx\nx\n" | ddev get $source
    ddev start -y >/dev/null
    DDEV_DEBUG="" ddev describe -j >/tmp/describe.json
    run ddev exec -s db 'echo ${DDEV_DATABASE}'
    assert_output "mysql:8.0"
    run jq -r .raw.services.redis.status </tmp/describe.json
    assert_output "running"
    run jq -r .raw.services.elasticsearch.status </tmp/describe.json
    assert_output "running"
    run jq -r .raw.services.memcached.status </tmp/describe.json
    assert_output "running"

    popd >/dev/null
    per_test_teardown
  done
}
