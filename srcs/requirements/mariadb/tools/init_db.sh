#!/bin/sh
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld --user=mysql --skip-networking &
pid=$!

echo "Waiting for MariaDB to start..."
for i in $(seq 30); do
    if mysql -u root -e "SELECT 1" > /dev/null 2>&1; then
        break
    fi
    sleep 1
done

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

kill $pid
wait $pid

exec mysqld --user=mysql --bind-address=0.0.0.0
