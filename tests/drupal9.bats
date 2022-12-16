# Requires bats-assert and bats-support
# brew tap kaos/shell &&
# brew install bats-core bats-assert bats-support jq mkcert yq
setup() {
  load setup.sh
}

teardown() {
  load teardown.sh
}

@test "drupal9" {
  load per_test.sh
  template="drupal9"
  for source in $PROJECT_SOURCE drud/ddev-platformsh; do
    per_test_setup

    run ddev exec -s db 'echo ${DDEV_DATABASE}'
    assert_output "mariadb:10.4"
    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'"
    assert_output "8.1"

    ddev exec 'touch ${PLATFORM_CACHE_DIR}/junk.txt'

    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "web"

    assert_equal $(ddev exec 'echo $PLATFORM_ROUTES | base64 -d | jq -r "keys[0]"') "https://${PROJNAME}.ddev.site/"
    assert_equal $(ddev exec 'echo $PLATFORM_ROUTES | base64 -d | jq -r .[].production_url') "https://${PROJNAME}.ddev.site/"
    ddev exec 'echo $PLATFORM_RELATIONSHIPS | base64 -d' >relationships.json
    echo "# PLATFORM_RELATIONSHIPS=$(cat relationships.json)" >&3

    assert_equal "$(jq -r .database[0].type <relationships.json)" "mariadb:10.4"
    assert_equal "$(jq -r .database[0].username <relationships.json)" "db"
    assert_equal "$(jq -r .database[0].password <relationships.json)" "db"
    assert_equal "$(jq -r .redis[0].hostname <relationships.json)" "redis"

    docker inspect ddev-${PROJNAME}-redis >/dev/null
    per_test_teardown
  done
}
