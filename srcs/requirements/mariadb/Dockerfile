FROM debian:buster

RUN apt-get -y update && apt-get -y install mariadb-server

COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./tools/script.sh /

CMD [ "/script.sh" ]
