FROM alpine:3.12

WORKDIR /app

RUN apk add --update --no-cache \
      curl \
      postgresql-client \
      gzip \
      bash \
      groff \
      less \
      python3 \
      py-pip \
      && pip install awscli

ADD pg_backup.sh .

RUN chmod +x pg_backup.sh

CMD ["./pg_backup.sh" ]