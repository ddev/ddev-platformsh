#!/usr/bin/env bash

#ddev-generated

export relationshipname=$1

read -r -d '' redis_stanza <<REDIS_EOF
  "${relationshipname}": [
    {
      "username": null,
      "scheme": "redis",
      "service": "cache",
      "fragment": null,
    "ip": "255.255.255.255",
      "hostname": "redis",
      "public": false,
      "cluster": "ddev-dummy-cluster",
      "host": "redis",
      "rel": "redis",
      "query": {},
      "path": null,
      "password": null,
      "type": "redis:6.0",
      "port": 6379,
      "host_mapped": false
    }
  ]
REDIS_EOF

printf "$redis_stanza"
