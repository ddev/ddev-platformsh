# Requires bats-assert and bats-support
# brew tap kaos/shell &&
# brew install bats-core bats-assert bats-support jq mkcert yq
setup() {
  load setup.sh
  load per_test.sh
}

teardown() {
  load teardown.sh
}

@test "php" {
  load per_test.sh
  template="php"
  for source in $PROJECT_SOURCE ddev/ddev-platformsh; do
    per_test_setup

    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'" 2>/dev/null
    assert_output "8.0"
    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "web"

    per_test_teardown
  done
}
