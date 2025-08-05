FROM alpine:3.18

RUN apk update && apk add --no-cache redis

COPY conf/redis.conf /etc/redis/redis.conf
COPY tools/start_redis.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start_redis.sh

EXPOSE 6379

CMD ["/usr/local/bin/start_redis.sh"]