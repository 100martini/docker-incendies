#!/bin/sh
set -e

# Initialize database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL in background
mysqld --user=mysql --skip-networking &
pid=$!

# Wait for MySQL to start
echo "Waiting for MariaDB to start..."
for i in $(seq 30); do
    if mysql -u root -e "SELECT 1" > /dev/null 2>&1; then
        break
    fi
    sleep 1
done

# Create database and user
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Stop background MySQL
kill $pid
wait $pid

# Start MySQL in foreground
exec mysqld --user=mysql --bind-address=0.0.0.0
