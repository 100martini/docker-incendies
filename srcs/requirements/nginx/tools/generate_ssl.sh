#!/bin/sh

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "Generating SSL certificate for ${DOMAIN_NAME}..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=MA/ST=Tangier/L=Tangier/O=42/OU=42/CN=${DOMAIN_NAME}"
fi

exec nginx -g "daemon off;"