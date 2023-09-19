FROM debian:bookworm-slim

ENV S3CFG_PATH=/home/worker/.s3cfg
ENV S3_HOST_BASE=ams3.digitaloceanspaces.com
ENV S3_HOST_BUCKET=%(bucket)s.ams3.digitaloceanspaces.com

ENV PSQL_PORT=5432
ENV PSQL_BACKUP_NAME=psql_backup

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN adduser worker

WORKDIR /home/worker

COPY configs/s3cfg-default backup.sh ./

RUN apt-get update \
    && apt-get --no-install-recommends -y install postgresql-client-15=15.3-0+deb12u1 s3cmd=2.3.0-1 gettext-base=0.21-12 \
    && rm -rf /var/lib/apt/lists/*

USER worker

ENTRYPOINT ["/bin/bash", "-c", "./backup.sh"]
