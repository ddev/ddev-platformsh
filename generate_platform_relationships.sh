#!/usr/bin/env bash

#ddev-generated

# Args:
# relationship name, like 'database' or 'cache'

export dbservice=$1
export dbtype=$2
export dbscheme


case $dbtype in
  mariadb* | mysql*)
    dbscheme="mysql"
    ;;

  postgres*)
    dbscheme="pgsql"
    ;;
  default)
    printf "no recognized dbtype: '${dbtype}'" && exit 1
    ;;
esac

read -r -d '' mariadb_stanza <<MARIADB_EOF
"database": [
  {
    "username": "db",
    "scheme": "${dbscheme}",
    "service": "${dbservice}",
    "fragment": null,
    "ip": "169.254.118.116",
    "hostname": "db",
    "public": false,
    "cluster": "dummyval",
    "host": "db",
    "rel": "mysql",
    "query": {
      "is_master": true
    },
    "path": "db",
    "password": "db",
    "type": "${dbtype}",
    "port": 3306,
    "host_mapped": false
  }
]
MARIADB_EOF

mysql_stanza='
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
'


postgres_stanza='
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
'

printf "$mariadb_stanza"
