FROM debian:buster

RUN apt-get update -y && apt-get install -y php-fpm php-mysql curl

COPY ./tools/scipt.sh /
COPY ./tools/wp-config.php /

CMD ["/script.sh"]
