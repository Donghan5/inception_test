FROM debian:buster

RUN apt-get update && apt-get upgrade -y

RUN apt-get nstall mariadb-server -y

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY conf/auto_config.sh /auto_config.sh

ENTRYPOINT ["bash", "auto_config.sh"]

EXPOSE 3306
