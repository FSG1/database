#!/bin/bash

if [ -f scripts/latest.sql ]; then
  if [ -f history/$(date +%Y%m%d.sql) ]; then
    rm -f history/$(date +%Y%m%d.sql)
  fi

  mv scripts/latest.sql history/$(date -r schemas/latest.sql +%Y%m%d.sql)
fi

pg_dump -U fmms -d fmms -s > scripts/latest.sql

# Delete changing of plpgsql because this will fail
sed -i "s/COMMENT ON EXTENSION plpgsql */-- /g" scripts/latest.sql
