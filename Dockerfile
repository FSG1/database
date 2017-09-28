FROM postgres:alpine

MAINTAINER Tobias Derksen <tobias.derksen@student.fontys.nl>

ENV POSTGRES_USER fmms
ENV POSTGRES_PASSWORD test123456

COPY scripts/before.sql /docker-entrypoint-initdb.d/0-before.sql
COPY scripts/latest.sql /docker-entrypoint-initdb.d/50-latest.sql
COPY scripts/after.sql /docker-entrypoint-initdb.d/99-after.sql
COPY scripts/clean.sh /docker-entrypoint-initdb.d/999-clean.sh
RUN chmod -R 777 /docker-entrypoint-initdb.d

EXPOSE 5432

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
