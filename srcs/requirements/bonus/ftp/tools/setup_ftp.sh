#!/bin/sh

adduser -D -s /bin/sh ftpuser
echo "ftpuser:ftppass123" | chpasswd

\chown -R ftpuser:ftpuser /var/www/html
chmod -R 755 /var/www/html

\exec vsftpd /etc/vsftpd/vsftpd.conf
