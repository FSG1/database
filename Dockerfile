FROM ubuntu:rolling

LABEL maintainer="Tobias Derksen <tobias.derksen@student.fontys.nl>"

RUN apt-get update && apt-get -y install postgresql postgresql-contrib
RUN  mkdir -p /tmp/init

COPY config/pg_hba.conf config/postgresql.conf /etc/postgresql/9.6/main/
COPY scripts/ /tmp/init/

WORKDIR /
USER postgres

# Create user and database
RUN service postgresql start && psql --command "CREATE USER module WITH SUPERUSER PASSWORD 'fmms';" && createdb -O module modulemanagement && service postgresql stop

# Import structure and data
RUN service postgresql start && for f in /tmp/init/*.sql; do psql -U module -d modulemanagement -f "$f"; done && service postgresql stop

EXPOSE 5432
VOLUME /var/lib/postgresql/9.6/main
STOPSIGNAL SIGTERM

ENTRYPOINT [ "/usr/lib/postgresql/9.6/bin/postgres" ]
CMD [ "-D", "/var/lib/postgresql/9.6/main", "-c", "config_file=/etc/postgresql/9.6/main/postgresql.conf" ]
