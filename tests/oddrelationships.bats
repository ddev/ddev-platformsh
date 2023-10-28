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
    run ddev exec -s db 'echo ${DDEV_DATABASE}' >/dev/null
    assert_output "mysql:8.0"
    run jq -r .raw.services.redis.status </tmp/describe.json
    assert_output "running"
    run jq -r .raw.services.elasticsearch.status </tmp/describe.json
    assert_output "running"
    run jq -r .raw.services.memcached.status </tmp/describe.json
    assert_output "running"
    ddev exec 'echo $PLATFORM_RELATIONSHIPS | base64 -d' >relationships.json 2>/dev/null

    echo "# PLATFORM_RELATIONSHIPS=$(cat relationships.json)" >&3

    assert_equal "$(jq -r .database[0].type <relationships.json)" "mysql:8.0"
    assert_equal "$(jq -r .database[0].host <relationships.json)" "db"
    assert_equal "$(jq -r .cachememcached[0].hostname <relationships.json)" "memcached"
    assert_equal "$(jq -r .cachememcached[0].port <relationships.json)" "11211"
    assert_equal "$(jq -r .cacheelasticsearch[0].hostname <relationships.json)" "elasticsearch"
    assert_equal "$(jq -r .cacheelasticsearch[0].port <relationships.json)" "9200"
    assert_equal "$(jq -r .rediscache[0].hostname <relationships.json)" "redis"
    assert_equal "$(jq -r .rediscache[0].port <relationships.json)" "6379"

    popd >/dev/null
    per_test_teardown
  done
}
