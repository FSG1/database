#!/bin/bash

if [ -f schemas/latest.sql ]; then
  if [ -f schemas/$(date +%Y%m%d.sql) ]; then
    rm -f schemas/$(date +%Y%m%d.sql)
  fi

  mv schemas/latest.sql schemas/$(date -r schemas/latest.sql +%Y%m%d.sql)
fi

pg_dump -U fmms -d fmms -s > schemas/latest.sql

# Delete changing of plpgsql because this will fail
sed -i "s/COMMENT ON EXTENSION plpgsql */-- /g" schemas/latest.sql
