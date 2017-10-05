#!/bin/bash

if [ ! -f /var/run/postgresql/9.6-main.pid ]
then
  service postgresql start
fi

psql --command "CREATE USER fmms WITH SUPERUSER PASSWORD 'fmms';"
createdb -O fmms fmms

for f in /tmp/init/*.sql;
do
  echo "$f"
  psql -U fmms -d fmms -f "$f"
done
