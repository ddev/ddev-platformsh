#!/usr/bin/env bats

# see setup.sh for instructions
setup() {
  load setup.sh
}

teardown() {
  load teardown.sh
}

@test "wordpress-bedrock" {
  load per_test.sh
  template="wordpress-bedrock"
  for source in $PROJECT_SOURCE ddev/ddev-platformsh; do
    per_test_setup
    printf "<?php\nprint 'DB_USER=' . getenv('DB_USER') . ' DB_PASSWORD=' . getenv('DB_PASSWORD');" >web/phpinfo.php
    run curl -s http://${PROJNAME}.ddev.site/phpinfo.php
    assert_line "DB_USER=db DB_PASSWORD=db"
    curl -s http://${PROJNAME}.ddev.site  | grep "Mindblown: a blog about"
    run ddev exec -s db 'echo ${DDEV_DATABASE}' 2>/dev/null
    assert_output "mariadb:10.4"
    run ddev exec 'echo $PLATFORM_RELATIONSHIPS | base64 -d | jq -r ".database[0].username"' 2>/dev/null
    assert_output "db"
    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'" 2>/dev/null
    assert_output "8.1"
    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "web"
    per_test_teardown
  done
}
