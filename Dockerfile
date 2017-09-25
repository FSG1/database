FROM postgres:alpine

MAINTAINER Tobias Derksen <tobias.derksen@student.fontys.nl>

ENV POSTGRES_USER fmms
ENV POSTGRES_PASSWORD test123456

RUN mkdir -p /docker-entrypoint-initdb.d
COPY schemas/20170925.sql /docker-entrypoint-initdb.d

EXPOSE 5432

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
