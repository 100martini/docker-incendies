FROM alpine:3.18

RUN apk add --no-cache ca-certificates
RUN wget https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz && \
    tar -xzf portainer-2.19.4-linux-amd64.tar.gz && \
    rm portainer-2.19.4-linux-amd64.tar.gz && \
    mv portainer/portainer /usr/local/bin/ && \
    rm -rf portainer

VOLUME /data
EXPOSE 9000

CMD ["/usr/local/bin/portainer"]