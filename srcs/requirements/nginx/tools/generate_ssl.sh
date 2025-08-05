#!/bin/sh
set -e

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "Generating SSL certificate for ${DOMAIN_NAME}..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=MA/ST=Benguerir/L=Benguerir/O=42/OU=1337/CN=${DOMAIN_NAME}"
fi

echo "Configuring nginx for domain: ${DOMAIN_NAME}"
envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

nginx -t

exec nginx -g "daemon off;"