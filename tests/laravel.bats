# Requires bats-assert and bats-support
# brew tap kaos/shell &&
# brew install bats-core bats-assert bats-support jq mkcert yq
setup() {
  load setup.sh
  load per_test.sh
  echo "# setup complete" >&3

}

teardown() {
  echo "# begin teardown" >&3
  load teardown.sh
}

@test "laravel" {
  load per_test.sh
  template="laravel"
  for source in $PROJECT_SOURCE platformsh/ddev-platformsh; do
    echo "# doing ddev get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
    per_test_setup

    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'"
    assert_output "8.0"
    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "public"
    docker inspect ddev-${PROJNAME}-redis >/dev/null
    per_test_teardown

  done
}
