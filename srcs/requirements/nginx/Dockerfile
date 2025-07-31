FROM alpine:3.18

RUN apk update && apk add --no-cache nginx openssl

# Create nginx user and directories
RUN adduser -D -s /bin/sh nginx && \
    mkdir -p /var/www/html && \
    mkdir -p /etc/nginx/ssl && \
    chown -R nginx:nginx /var/www/html

# Copy configurations and tools
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/generate_ssl.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/generate_ssl.sh

# Generate SSL certificate
RUN /usr/local/bin/generate_ssl.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
