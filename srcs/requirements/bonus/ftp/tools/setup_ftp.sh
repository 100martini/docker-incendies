#!/bin/sh

# Create FTP user
adduser -D -s /bin/sh ftpuser
echo "ftpuser:ftppass123" | chpasswd

# Set permissions for WordPress files
chown -R ftpuser:ftpuser /var/www/html
chmod -R 755 /var/www/html

# Start vsftpd
exec vsftpd /etc/vsftpd/vsftpd.conf
