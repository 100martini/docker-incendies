FROM alpine:3.18

RUN apk update && apk add --no-cache \
    nginx \
    openssl \
    gettext && \
    mkdir -p /var/www/html /etc/nginx/ssl && \
    chown -R nginx:nginx /var/www/html

COPY conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY tools/generate_ssl.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/generate_ssl.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/generate_ssl.sh"]