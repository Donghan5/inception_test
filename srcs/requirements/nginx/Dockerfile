FROM debian:buster

RUN apt-get -y update && apt-get install -y nginx openssl

COPY ./tools/srcipt.sh /

CMD ["/srcipt.sh"]
