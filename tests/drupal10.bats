# Requires bats-assert and bats-support
# brew tap kaos/shell &&
# brew install bats-core bats-assert bats-support jq mkcert yq
setup() {
  load setup.sh
}

teardown() {
  load teardown.sh
}

@test "drupal10" {
  load per_test.sh
  template="drupal10"
  for source in $PROJECT_SOURCE ddev/ddev-platformsh; do
    per_test_setup

    ddev exec drush cr 2>/dev/null

    run curl -L -s http://${PROJNAME}.ddev.site/
    assert_output --partial "Test of ddev-platformsh on drupal10"

    run ddev exec -s db 'echo ${DDEV_DATABASE}' 2>/dev/null
    assert_output "mariadb:10.11"
    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'" 2>/dev/null
    assert_output "8.2"

    ddev exec 'touch ${PLATFORM_CACHE_DIR}/junk.txt' 2>/dev/null

    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "web"

    assert_equal "$(ddev exec 'echo $PLATFORM_ROUTES 2>/dev/null | base64 -d | jq -r "keys[0]"')" "https://${PROJNAME}.ddev.site/"
    ddev exec 'echo $PLATFORM_RELATIONSHIPS | base64 -d' >relationships.json 2>/dev/null
    echo "# PLATFORM_RELATIONSHIPS=$(cat relationships.json)" >&3
    ddev exec 'echo $PLATFORM_ROUTES | base64 -d' >routes.json 2>/dev/null
    echo "# PLATFORM_ROUTES=$(cat routes.json)" >&3

    assert_equal "$(jq -r .database[0].type <relationships.json)" "mariadb:10.11"
    assert_equal "$(jq -r .database[0].username <relationships.json)" "db"
    assert_equal "$(jq -r .database[0].password <relationships.json)" "db"
    assert_equal "$(jq -r .redis[0].hostname <relationships.json)" "redis"

    docker inspect ddev-${PROJNAME}-redis >/dev/null
    per_test_teardown
  done
}
