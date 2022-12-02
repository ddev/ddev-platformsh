#!/usr/bin/env bash

#ddev-generated

# Args:
# service name, like 'dbmysql' or 'db'
# db type, like mariadb:10.4 or postgres:14
# relationshipname, like "database" (but it's arbitrary, used in PLATFORM_RELATIONSHIPS)

export dbservice=$1
export dbtype=$2
export relationshipname=$3
export dbscheme
export dbport

case $dbtype in
  mariadb* | mysql*)
    dbscheme="mysql"
    dbport=3306
    rel="mysql"
    ;;

  postgres*)
    dbscheme="pgsql"
    dbport=5432
    rel="pgsql"
    ;;
  default)
    printf "no recognized dbtype: '${dbtype}'" && exit 1
    ;;
esac

read -r -d '' db_stanza <<DB_EOF
"${relationshipname}": [
  {
    "username": "db",
    "scheme": "${dbscheme}",
    "service": "${dbservice}",
    "fragment": null,
    "ip": "255.255.255.255",
    "hostname": "db",
    "public": false,
    "cluster": "ddev-dummy-cluster",
    "host": "db",
    "rel": "${rel}",
    "query": {
      "is_master": true
    },
    "path": "db",
    "password": "db",
    "type": "${dbtype}",
    "port": ${dbport},
    "host_mapped": false
  }
]
DB_EOF

printf "$db_stanza"
