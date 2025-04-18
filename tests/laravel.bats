#!/usr/bin/env bats

# see setup.sh for instructions
setup() {
  load setup.sh
  load per_test.sh
}

teardown() {
   load teardown.sh
}

@test "laravel" {
  load per_test.sh
  template="laravel"
  for source in $PROJECT_SOURCE ddev/ddev-platformsh; do
    per_test_setup

    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'" 2>/dev/null
    assert_output "8.0"
    ddev describe -j >describe.json 2>/dev/null
    run  jq -r .raw.docroot <describe.json
    assert_output "public"
    docker inspect ddev-${PROJNAME}-redis >/dev/null
    per_test_teardown

  done
}
