FROM golang:1.18.1-alpine3.15

ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PWD=password

COPY . /

RUN mkdir -p /home/app \
    && chmod +x /entrypoint.sh \
    && chmod +x /main.go

ENTRYPOINT ["/entrypoint.sh"]