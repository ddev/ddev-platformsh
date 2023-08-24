#!/usr/bin/env bash

#ddev-generated

# Create a stanza for $PLATFORM_ROUTES

# Args:
# route (like https://{default}/)
# id
# production_url
# upstream
# type
# original_url

export route=$1
export id=$2
export production_url=$3
export upstream=$4
export type=$5
export original_url=$6

idline='"id": null'
if [ ! -z ${id} ]; then
  idline="\"id\": \"${id}\""
fi

read -r -d '' route_stanza <<ROUTE_EOF
"${route}": {
    "primary": true,
    ${idline},
    "production_url": "${production_url}",
    "attributes": {},
    "upstream": "${upstream}",
    "type": "${type}",
    "original_url": "${original_url}"
  }
ROUTE_EOF

printf "${route_stanza}"
