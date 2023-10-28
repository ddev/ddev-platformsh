# Requires bats-assert and bats-support
# brew tap kaos/shell &&
# brew install bats-core bats-assert bats-support jq mkcert yq
setup() {
  load setup.sh
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
}

teardown() {
  load teardown.sh
}

# mariadb is called mysql in platform.sh
@test "composerversion" {
  template="composerversion"
  load per_test.sh
  for source in "${PROJECT_SOURCE}"; do
      rm -rf ${TESTDIR} && mkdir -p ${TESTDIR}
      for t in $PROJECT_SOURCE/tests/testdata/${template}/*; do
        cp -r $t/. ${TESTDIR}
        pushd ${TESTDIR} >/dev/null
        ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
        echo "# doing ddev config --project-name=${PROJNAME}" >&3
        ddev config --project-name=${PROJNAME} >/dev/null
        echo "# doing ddev get $source with template ${template} PROJNAME=${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
        printf "x\nx\nx\n" | ddev get $source
        ddev start -y >/dev/null
        base=$(basename $t)
        expectedComposerVersion=${base#*_}
        echo "# base=${base} expectedComposerVersion=${expectedComposerVersion}" >&3
        run ddev exec "composer --version | awk '{print \$3}'" 2>/dev/null

        # If version has a caret, then we just want the first number
        # Otherwise we use the explicit value provided
        if [[ "$expectedComposerVersion" == "^"* ]]; then
          expectedComposerVersion=${expectedComposerVersion:1:2}
          assert_output --regexp "^${expectedComposerVersion}"
        else
          assert_output "$expectedComposerVersion"
        fi
      done
    popd >/dev/null
    per_test_teardown
  done
}
