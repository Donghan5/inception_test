FROM debian:buster

RUN apt-get update -y && apt-get install -y php-fpm php-mysql curl

COPY ./tools/script.sh /
COPY ./tools/wp-config.php /var/www/html/wp-config.php

CMD ["/script.sh"]
