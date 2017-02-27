FROM python:2-alpine

ENV PGADMIN_VERSION_MAJOR 1
ENV PGADMIN_VERSION_MINOR 2

RUN apk add --no-cache alpine-sdk postgresql postgresql-dev \
 && echo "https://ftp.postgresql.org/pub/pgadmin3/pgadmin4/v${PGADMIN_VERSION_MAJOR}.${PGADMIN_VERSION_MINOR}/pip/pgadmin4-${PGADMIN_VERSION_MAJOR}.${PGADMIN_VERSION_MINOR}-py2-none-any.whl" > requirements.txt \
 && pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt \
 && apk del alpine-sdk \
 && addgroup -g 50 -S pgadmin \
 && adduser -D -S -h /pgadmin -s /sbin/nologin -u 1000 -G pgadmin pgadmin \
 && mkdir -p /data/config /data/storage /data/sessions; \
 chown -R 1000:50 /data

ENV SERVER_MODE   false
ENV SERVER_PORT   5999
ENV MAIL_SERVER   mail.example.tld
ENV MAIL_PORT     465
ENV MAIL_USE_SSL  true
ENV MAIL_USERNAME username
ENV MAIL_PASSWORD password

COPY LICENSE config_local.py /usr/local/lib/python2.7/site-packages/pgadmin4/

USER pgadmin:pgadmin

CMD [ "python", "./usr/local/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py" ]

EXPOSE $SERVER_PORT

VOLUME /data/