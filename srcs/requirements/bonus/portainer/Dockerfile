FROM alpine:3.18

RUN apk update && apk add --no-cache \
    wget \
    tar \
    ca-certificates && \
    mkdir -p /data /app

WORKDIR /app

RUN wget https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz && \
    tar -xzf portainer-2.19.4-linux-amd64.tar.gz && \
    rm portainer-2.19.4-linux-amd64.tar.gz && \
    chmod +x portainer/portainer

EXPOSE 9000

VOLUME ["/data"]

ENTRYPOINT ["/app/portainer/portainer"]
CMD ["--bind=:9000", "--data=/data"]