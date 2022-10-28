#!/usr/bin/env bash

#ddev-generated

read -r -d '' redis_stanza <<ELASTICSEARCH_EOF
  "essearch": [
    {
      "username": null,
      "scheme": "http",
      "service": "search",
      "fragment": null,
      "ip": "169.254.158.91",
      "hostname": "elasticsearch",
      "public": false,
      "cluster": "6ez5tx3nxrqy4-main-bvxea6i",
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

printf "$redis_stanza"
