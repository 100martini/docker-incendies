FROM alpine:3.18

RUN apk update && apk add --no-cache vsftpd

# Create directories
RUN mkdir -p /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/setup_ftp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_ftp.sh

EXPOSE 21 21000-21010

CMD ["/usr/local/bin/setup_ftp.sh"]
