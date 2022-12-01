#!/usr/bin/env bash

#ddev-generated

export relationshipname=$1

read -r -d '' elasticsearch_stanza <<ELASTICSEARCH_EOF
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
ELASTICSEARCH_EOF

printf "$elasticsearch_stanza"
