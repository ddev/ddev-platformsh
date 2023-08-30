#!/usr/bin/env bash

#ddev-generated

export relationshipname=$1

read -r -d '' search_stanza <<SEARCH_EOF
  "${relationshipname}": [
    {
      "username": null,
      "scheme": "http",
      "service": "search",
      "fragment": null,
      "ip": "255.255.255.255",
      "hostname": "elasticsearch",
      "public": false,
      "cluster": "ddev-dummy-cluster",
      "host": "elasticsearch",
      "rel": "elasticsearch",
      "query": {},
      "path": null,
      "password": null,
      "type": "elasticsearch:7.5",
      "port": 9200,
      "host_mapped": false
    }
  ]
SEARCH_EOF

printf "$search_stanza"
