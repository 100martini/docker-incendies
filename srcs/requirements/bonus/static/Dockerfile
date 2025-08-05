FROM alpine:3.18

RUN apk update && apk add --no-cache python3

WORKDIR /var/www/html

COPY tools/ /var/www/html/

EXPOSE 8081

CMD ["python3", "-m", "http.server", "8081", "--bind", "0.0.0.0"]