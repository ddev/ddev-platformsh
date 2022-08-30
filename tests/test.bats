setup() {
  set -eu -o pipefail
  export PROJECT_SOURCE="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/testplatformsh
  export PROJNAME=test-platformsh
  export DDEV_NON_INTERACTIVE=true
  brew_prefix=$(brew --prefix)
  docker volume rm $PROJNAME-mariadb || true
  load "${brew_prefix}/lib/bats-support/load.bash"
  load "${brew_prefix}/lib/bats-assert/load.bash"
}

teardown() {
  set -eu -o pipefail
  ddev delete -Oy ${PROJNAME}
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

per_test_setup() {
  set -e -o pipefail
  set +u
  ddev delete -Oy ${PROJNAME} || true

  rm -rf ${TESTDIR} && mkdir -p ${TESTDIR} && cd ${TESTDIR}

  curl -sfL -o /tmp/testtemplate.tgz "https://github.com/platformsh-templates/${template}/tarball/master"
  tar -zxf /tmp/testtemplate.tgz --strip-components=1
  # Start with bogus settings so we know we got the right stuff when testing
  ddev config --project-name=${PROJNAME} --php-version=5.6 --database=mariadb:5.5 --docroot=x --create-docroot --project-type=php --web-environment-add=PLATFORMSH_CLI_TOKEN=notokenrightnow,PLATFORM_PROJECT=notyet,PLATFORM_ENVIRONMENT=notyet
  ddev get ${PROJECT_SOURCE}
  ddev restart >/dev/null
}

per_test_teardown() {
  ddev delete -Oy ${PROJNAME} || true
}

@test "drupal9" {
  template="drupal9"
  for source in $PROJECT_SOURCE platformsh/ddev-platformsh; do
    echo "# ddev get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
    per_test_setup

    run ddev exec -s db 'echo ${DDEV_DATABASE}'
    assert_output "mariadb:10.4"
    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'"
    assert_output "8.0"
    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "web"

    docker inspect ddev-${PROJNAME}-redis >/dev/null
    per_test_teardown
  done
}


@test "php" {
  template="php"
  for source in $PROJECT_SOURCE platformsh/ddev-platformsh; do
    echo "# ddev get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
    per_test_setup

    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'"
    assert_output "8.0"
    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "web"
  done
}


@test "laravel" {
  template="laravel"
  for source in $PROJECT_SOURCE platformsh/ddev-platformsh; do
    echo "# ddev get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
    per_test_setup

    run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'"
    assert_output "8.0"
    ddev describe -j >describe.json
    run  jq -r .raw.docroot <describe.json
    assert_output "public"
    docker inspect ddev-${PROJNAME}-redis >/dev/null

  done
}
