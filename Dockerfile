FROM ubuntu:rolling

LABEL maintainer="Tobias Derksen <tobias.derksen@student.fontys.nl>"

RUN apt-get update && apt-get -y install postgresql postgresql-contrib nano less && mkdir -p /init

COPY config/pg_hba.conf config/postgresql.conf /etc/postgresql/9.6/main/
COPY scripts/ /init/
COPY import.sh startup.sh /

USER postgres
RUN /import.sh

# USER root
# CMD ["/usr/lib/postgresql/9.6/bin/postgres"]
# CMD ["/bin/bash"]

CMD ["/startup.sh"]
