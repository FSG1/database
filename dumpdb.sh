#!/bin/bash

if [ -f scripts/10-latest.sql ]; then
  if [ -f history/$(date +%Y%m%d.sql) ]; then
    rm -f history/$(date +%Y%m%d.sql)
  fi

  mv scripts/10-latest.sql history/$(date -r scripts/10-latest.sql +%Y%m%d.sql)
fi

pg_dump -U fmms -d fmms -s > scripts/10-latest.sql

# Delete changing of plpgsql because this will fail
sed -i "s/COMMENT ON EXTENSION plpgsql */-- /g" scripts/10-latest.sql
