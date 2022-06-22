setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/testelasticsearch
  mkdir -p $TESTDIR
  cp -r tests/testdata/.platform* ${TESTDIR}
  export PROJNAME=test-platformsh
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME} --web-environment-add=PLATFORMSH_CLI_TOKEN=notokenrightnow
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME}
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  [ "$(ddev exec -s db 'echo ${DDEV_DATABASE}')" = "mysql:8.0" ]
  [ "$(ddev exec 'echo ${DDEV_PHP_VERSION}')" = "8.0" ]
  docker inspect ddev-${PROJNAME}-redis >/dev/null
}

# Can't do release yet
#@test "install from release" {
#  set -eu -o pipefail
#  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
#  echo "# ddev get drud/ddev-platformsh with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
#  ddev get drud/ddev-addon-template
#  ddev restart
#}
