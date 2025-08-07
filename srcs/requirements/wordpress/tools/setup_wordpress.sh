#!/bin/sh

if [ -f /run/secrets/db_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi
if [ -f /run/secrets/admin_password ]; then
    WP_ADMIN_PASSWORD=$(cat /run/secrets/admin_password)
fi
if [ -f /run/secrets/user_password ]; then
    WP_USER_PASSWORD=$(cat /run/secrets/user_password)
fi
if [ -f /run/secrets/redis_password ]; then
    REDIS_PASSWORD=$(cat /run/secrets/redis_password)
fi

echo "Waiting for MariaDB..."
while ! nc -z mariadb 3306; do
    sleep 1
done
echo "MariaDB is ready!"

echo "Waiting for Redis..."
while ! nc -z redis 6379; do
    sleep 1
done
echo "Redis is ready!"

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Creating WordPress configuration..."
    
    su -s /bin/sh wordpress -c "wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306"
    
    echo "Configuring Redis cache..."
    su -s /bin/sh wordpress -c "wp config set WP_REDIS_HOST redis"
    su -s /bin/sh wordpress -c "wp config set WP_REDIS_PORT 6379"
    su -s /bin/sh wordpress -c "wp config set WP_REDIS_PASSWORD '$REDIS_PASSWORD'"
    su -s /bin/sh wordpress -c "wp config set WP_REDIS_DATABASE 0"
    su -s /bin/sh wordpress -c "wp config set WP_CACHE true --raw"
    su -s /bin/sh wordpress -c "wp config set WP_MEMORY_LIMIT 256M"
    
    if ! su -s /bin/sh wordpress -c "wp core is-installed"; then
        echo "Installing WordPress..."
        su -s /bin/sh wordpress -c "wp core install \
            --url=$WP_URL \
            --title='$WP_TITLE' \
            --admin_user=$WP_ADMIN_USER \
            --admin_password=$WP_ADMIN_PASSWORD \
            --admin_email=$WP_ADMIN_EMAIL"
        
        su -s /bin/sh wordpress -c "wp user create $WP_USER $WP_USER_EMAIL \
            --user_pass=$WP_USER_PASSWORD \
            --role=author"
        
        echo "WordPress installation completed!"
    fi
    
    su -s /bin/sh wordpress -c "wp plugin install redis-cache --activate" || true
    
    su -s /bin/sh wordpress -c "wp redis enable" || true
    
else
    echo "Updating Redis configuration..."
    su -s /bin/sh wordpress -c "wp config set WP_REDIS_HOST redis"
    su -s /bin/sh wordpress -c "wp config set WP_REDIS_PORT 6379"
    su -s /bin/sh wordpress -c "wp config set WP_REDIS_PASSWORD '$REDIS_PASSWORD'"
    su -s /bin/sh wordpress -c "wp config set WP_REDIS_DATABASE 0"
    su -s /bin/sh wordpress -c "wp config set WP_CACHE true --raw"
    su -s /bin/sh wordpress -c "wp config set WP_MEMORY_LIMIT 256M"
    
    su -s /bin/sh wordpress -c "wp redis enable" || true
fi

chown -R wordpress:wordpress /var/www/html

exec php-fpm81 -F