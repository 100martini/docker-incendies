#!/bin/sh

if [ -f /run/secrets/redis_password ]; then
    REDIS_PASSWORD=$(cat /run/secrets/redis_password)
    sed -i "s/requirepass .*/requirepass $REDIS_PASSWORD/" /etc/redis/redis.conf
fi

exec redis-server /etc/redis/redis.conf