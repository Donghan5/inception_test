FROM debian:buster

RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install wget

RUN apt-get -y install sendmail

RUN apt-get install -y php7.3\
		php-fpm\
		php-mysql\
		php-pdo\
		php-cgi\
		php-gd php-cli\
		php-mbstring\
		mariadb-client

RUN wget https://wordpress.org/wordpress-6.0.tar.gz -P /var/www/html
RUN cd /var/www/html && tar -xzf wordpress-6.0.tar.gz && rm wordpress-6.0.tar.gz

COPY ./conf/php.conf /etc/php/7.3/fpm/pool.d/www.conf

# RUN chown -R root:root /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress
RUN chmod 755 /var/www/html/wordpress

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY conf/auto_config.sh auto_config.sh

ENTRYPOINT [ "/bin/sh", "auto_config.sh" ]
