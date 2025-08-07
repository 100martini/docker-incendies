FROM alpine:3.18

RUN apk update && apk add --no-cache \
    php81 \
    php81-fpm \
    php81-mysqli \
    php81-json \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-fileinfo \
    php81-mbstring \
    php81-openssl \
    php81-xml \
    php81-zip \
    php81-redis \
    php81-phar \
    php81-tokenizer \
    php81-ctype \
    wget \
    unzip \
    netcat-openbsd && \
    adduser -D -s /bin/sh wordpress && \
    mkdir -p /var/www/html /run/php && \
    chown -R wordpress:wordpress /var/www/html

WORKDIR /var/www/html

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    chown -R wordpress:wordpress /var/www/html

COPY conf/www.conf /etc/php81/php-fpm.d/www.conf
COPY tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

CMD ["/usr/local/bin/setup_wordpress.sh"]