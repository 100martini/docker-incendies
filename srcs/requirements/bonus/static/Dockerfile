FROM alpine:3.18

RUN apk update && apk add --no-cache nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/ /var/www/html/
EXPOSE 8081

CMD ["nginx", "-g", "daemon off;"]
