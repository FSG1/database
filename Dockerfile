FROM ubuntu:rolling

LABEL maintainer="Tobias Derksen <tobias.derksen@student.fontys.nl>"

RUN apt-get update && apt-get -y install postgresql postgresql-contrib nano less && mkdir -p /tmp/init

COPY config/pg_hba.conf config/postgresql.conf /etc/postgresql/9.6/main/
COPY scripts/ /tmp/init/
COPY import.sh /tmp/

USER postgres

WORKDIR /
RUN sh -c tmp/import.sh

EXPOSE 5432
VOLUME /var/lib/postgresql/9.6/main

STOPSIGNAL SIGTERM

ENTRYPOINT [ "/usr/lib/postgresql/9.6/bin/postgres" ]
CMD [ "-D", "/var/lib/postgresql/9.6/main", "-c", "config_file=/etc/postgresql/9.6/main/postgresql.conf" ]
