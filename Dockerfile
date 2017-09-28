FROM postgres:alpine

MAINTAINER Tobias Derksen <tobias.derksen@student.fontys.nl>

ENV POSTGRES_USER fmms
ENV POSTGRES_PASSWORD test123456

RUN mkdir -p /docker-entrypoint-initdb.d
COPY before.sql /docker-entrypoint-initdb.d/0-before.sql
COPY after.sql /docker-entrypoint-initdb.d/9999-after.sql
COPY schemas/latest.sql /docker-entrypoint-initdb.d/80-latest.sql

EXPOSE 5432

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
