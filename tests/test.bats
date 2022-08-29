setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/testplatformsh
  export PROJNAME=test-platformsh
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} || true
  brew_prefix=$(brew --prefix)
  load "${brew_prefix}/lib/bats-support/load.bash"
  load "${brew_prefix}/lib/bats-assert/load.bash"
}

teardown() {
  set -eu -o pipefail
  ddev delete -Oy ${PROJNAME}
#  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "drupal9" {
  set -e -o pipefail
  set +u
  template="drupal9"
  rm -rf ${TESTDIR} && mkdir -p ${TESTDIR} && cd ${TESTDIR}

  curl -sfL -o /tmp/testtemplate.tgz "https://github.com/platformsh-templates/${template}/tarball/master"
  tar -zxf /tmp/testtemplate.tgz --strip-components=1
  # Start with bogus settings so we know we got the right stuff when testing
  ddev config --project-name=${PROJNAME} --php-version=5.6 --database=mariadb:5.5 --docroot=x --create-docroot --project-type=php --web-environment-add=PLATFORMSH_CLI_TOKEN=notokenrightnow,PLATFORM_PROJECT=notyet,PLATFORM_ENVIRONMENT=notyet
  echo "# ddev get ${DIR} with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}

  ddev restart >/dev/null
  run ddev exec -s db 'echo ${DDEV_DATABASE}'
  assert_output "mariadb:10.4"
  run ddev exec "php --version | awk 'NR==1 { sub(/\.[0-9]+$/, \"\", \$2); print \$2 }'"
  assert_output "8.0"
  ddev describe -j >describe.json
  run  jq -r .raw.docroot <describe.json
  assert_output "web"

  docker inspect ddev-${PROJNAME}-redis >/dev/null
}

#@test "install from release" {
#  set -eu -o pipefail
#  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
#  echo "# ddev get drud/ddev-platformsh with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
#  ddev get platformsh/ddev-platformsh
#  ddev restart >/dev/null
#  [ "$(ddev exec -s db 'echo ${DDEV_DATABASE}')" = "mysql:8.0" ]
#  [ "$(ddev exec 'echo ${DDEV_PHP_VERSION}')" = "8.0" ]
#  docker inspect ddev-${PROJNAME}-redis >/dev/null
#}
