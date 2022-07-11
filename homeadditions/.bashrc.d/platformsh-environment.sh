#ddev-generated
export PATH=$PATH:/var/www/html/.global/bin
# TODO: Review which of these matters and which can be dummied up
export PLATFORM_TREE_ID=2dc356f2fea13ef683f9adc5fc5bd28e05ad992a
export PLATFORM_PROJECT_ENTROPY="$(echo $RANDOM | shasum -a 256 | awk '{print $1}')"
export PLATFORM_APP_DIR=/var/www/html
# PLATFORM_APPLICATION_NAME should be the actual upstream name, like "drupal"
#export PLATFORM_ENVIRONMENT=$(platform project:info default_branch)
export PLATFORM_ENVIRONMENT=main

# PLATFORM_PROJECT should be the real upstream project
#export PLATFORM_PROJECT=$(platform project:info id)
export PLATFORM_PROJECT=${DDEV_PROJECT}

platform_routes=$(cat <<-ENDROUTES
{
  "${DDEV_PRIMARY_URL}": {
    "primary": true,
    "id": null,
    "production_url": "${DDEV_PRIMARY_URL}",
    "attributes": {},
    "upstream": "drupal",
    "original_url": "https://{default}/"  }
}
ENDROUTES
)

export PLATFORM_ROUTES="$( if base64 --version >/dev/null 2>&1; then echo -n ${platform_routes} | base64 -w0; else echo -n ${platform_routes} | base64; fi)"
# TODO: Use real PLATFORM_VARIABLES?
PLATFORM_VARIABLES=e30=
# TODO: Consider populating $USER in web container by default
USER=$(id -u -n)

for item in .global/environment .environment; do
  if [ -f "${item}" ]; then
    . "${item}"
  fi
done
