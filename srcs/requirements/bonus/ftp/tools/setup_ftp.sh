#!/bin/sh

adduser -D -s /bin/sh ${FTP_USER}
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

chown -R ${FTP_USER}:${FTP_USER} /var/www/html
chmod -R 755 /var/www/html

exec vsftpd /etc/vsftpd/vsftpd.conf