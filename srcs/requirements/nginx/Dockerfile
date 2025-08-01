FROM alpine:3.18

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /var/www/html && \
    mkdir -p /etc/nginx/ssl && \
    chown -R nginx:nginx /var/www/html

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/generate_ssl.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/generate_ssl.sh

RUN /usr/local/bin/generate_ssl.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]