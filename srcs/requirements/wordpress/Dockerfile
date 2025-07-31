FROM alpine:3.18

# Install PHP-FPM and required extensions
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
    wget \
    unzip \
    netcat-openbsd && \
    ln -s /usr/bin/php81 /usr/bin/php

# Create wordpress user and directories
RUN adduser -D -s /bin/sh wordpress && \
    mkdir -p /var/www/html && \
    chown -R wordpress:wordpress /var/www/html && \
    mkdir -p /run/php

# Download and install WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R wordpress:wordpress /var/www/html

# Download WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/wp-cli/master/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy configuration files
COPY conf/www.conf /etc/php81/php-fpm.d/www.conf
COPY tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

CMD ["/usr/local/bin/setup_wordpress.sh"]
