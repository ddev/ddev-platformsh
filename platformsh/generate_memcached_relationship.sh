#!/usr/bin/env bash

#ddev-generated

read -r -d '' memcached_stanza <<MEMCACHED_EOF
"cache": [
  {
    "service": "memcached",
    "ip": "255.255.255.255",
    "hostname": "memcached",
    "cluster": "ddev-dummy-cluster",
    "host": "memcached",
    "rel": "memcached",
    "scheme": "memcached",
    "type": "memcached:1.6",
    "port": 11211
  }
]
MEMCACHED_EOF

printf "$memcached_stanza"
