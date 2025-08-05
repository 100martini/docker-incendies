#!/bin/sh

if [ -f /run/secrets/ftp_password ]; then
    FTP_PASSWORD=$(cat /run/secrets/ftp_password)
fi

adduser -D -h /home/$FTP_USER -s /bin/sh $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

ln -s /var/www/html /home/$FTP_USER/wordpress
chown -h $FTP_USER:$FTP_USER /home/$FTP_USER/wordpress

mkdir -p /var/run/vsftpd/empty

exec vsftpd /etc/vsftpd/vsftpd.conf