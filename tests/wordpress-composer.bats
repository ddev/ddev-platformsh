# Requires bats-assert and bats-support
# brew tap kaos/shell &&
# brew install bats-core bats-assert bats-support jq mkcert yq
setup() {
  load setup.sh
}

teardown() {
  load teardown.sh
}

@test "wordpress-composer" {
  load per_test.sh
  template="wordpress-composer"
  for source in $PROJECT_SOURCE ddev/ddev-platformsh; do
    per_test_setup

    run ddev exec -s db 'echo ${DDEV_DATABASE}' 2>/dev/null
    assert_output "mariadb:10.4"
    run ddev exec 'echo $PLATFORM_RELATIONSHIPS | base64 -d | jq -r ".database[0].username"' 2>/dev/null
    assert_output "db"
    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'" 2>/dev/null
    assert_output "8.1"
    run ddev exec ls wordpress/wp-config.php 2>/dev/null
    assert_output "wordpress/wp-config.php"
    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "wordpress"
    per_test_teardown
  done
}
