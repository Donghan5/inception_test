FROM debian:buster

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y netcat

RUN apt install nginx -y

RUN apt-get install openssl -y

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -newkey rsa:4096 -days 42 -nodes -x509 \
-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=donghank.42.fr/UID=donghank" \
-out /etc/ssl/certs/inception.crt \
-keyout /etc/ssl/private/inception.key

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD [ "nginx", "-g", "daemon off;" ]
