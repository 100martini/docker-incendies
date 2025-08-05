#!/bin/sh

if [ -f /run/secrets/ftp_password ]; then
    FTP_PASSWORD=$(cat /run/secrets/ftp_password)
fi

adduser -D -h /home/$FTP_USER/ftp -s /bin/sh $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

mkdir -p /home/$FTP_USER/ftp/files
chown -R $FTP_USER:$FTP_USER /home/$FTP_USER/ftp/files
chmod a-w /home/$FTP_USER/ftp

mkdir -p /var/run/vsftpd/empty

exec vsftpd /etc/vsftpd/vsftpd.conf
