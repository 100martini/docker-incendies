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

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Creating WordPress configuration..."
    
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root
    
    if ! wp core is-installed --allow-root; then
        echo "Installing WordPress..."
        wp core install \
            --url=$WP_URL \
            --title="$WP_TITLE" \
            --admin_user=$WP_ADMIN_USER \
            --admin_password=$WP_ADMIN_PASSWORD \
            --admin_email=$WP_ADMIN_EMAIL \
            --allow-root
        
        wp user create $WP_USER $WP_USER_EMAIL \
            --user_pass=$WP_USER_PASSWORD \
            --role=author \
            --allow-root
        
        echo "WordPress installation completed!"
    fi
    
    if nc -z redis 6379; then
        echo "Configuring Redis cache..."
        wp config set WP_REDIS_HOST redis --allow-root
        wp config set WP_REDIS_PORT 6379 --allow-root
        wp config set WP_REDIS_PASSWORD $REDIS_PASSWORD --allow-root
        wp plugin install redis-cache --activate --allow-root || true
        wp redis enable --allow-root || true
    fi
fi

exec php-fpm81 -F