#!/usr/bin/env bash

# Args:
# relationship name, like 'database' or 'cache'
mariadb_stanza=`
  "database": [
    {
      "username": "user",
      "scheme": "mysql",
      "service": "mysqldb",
      "fragment": null,
      "ip": "169.254.118.116",
      "hostname": "gzanmenz3vkkimeol5i54acinm.mysqldb.service._.fr-3.platformsh.site",
      "public": false,
      "cluster": "ohppb3vrezyog-master-7rqtwti",
      "host": "database.internal",
      "rel": "mysql",
      "query": {
        "is_master": true
      },
      "path": "main",
      "password": "",
      "type": "mysql:10.2",
      "port": 3306,
      "host_mapped": false
    }
  ]
`

mysql_stanza=`
  "database": [
    {
      "username": "user",
      "scheme": "mysql",
      "service": "mysqldb",
      "fragment": null,
      "ip": "169.254.118.116",
      "hostname": "gzanmenz3vkkimeol5i54acinm.mysqldb.service._.fr-3.platformsh.site",
      "public": false,
      "cluster": "ohppb3vrezyog-master-7rqtwti",
      "host": "database.internal",
      "rel": "mysql",
      "query": {
        "is_master": true
      },
      "path": "main",
      "password": "",
      "type": "mysql:10.2",
      "port": 3306,
      "host_mapped": false
    }
  ]
`


postgres_stanza=`
  "database": [
    {
      "username": "user",
      "scheme": "mysql",
      "service": "mysqldb",
      "fragment": null,
      "ip": "169.254.118.116",
      "hostname": "gzanmenz3vkkimeol5i54acinm.mysqldb.service._.fr-3.platformsh.site",
      "public": false,
      "cluster": "ohppb3vrezyog-master-7rqtwti",
      "host": "database.internal",
      "rel": "mysql",
      "query": {
        "is_master": true
      },
      "path": "main",
      "password": "",
      "type": "mysql:10.2",
      "port": 3306,
      "host_mapped": false
    }
  ]
`

