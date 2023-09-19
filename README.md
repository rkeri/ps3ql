# ps3ql - Postgresql s3 backup solution

This little tool serves as a solution to dump and backup your database to an s3 provider.

## Usage

Just run the image with the required variables.

Examples can be found under ./manifests directory

## Environment variables

- S3_ACCESS_KEY: S3 access key
- S3_SECRET_KEY: S3 secret key
- PSQL_BACKUP_NAME: PSQL backup filename, unix timestamp will be attached to it, defaults to "psql_backup"
- PSQL_ADDRESS: Address of the postgres instance
- PSQL_PORT: Port of the postgres instance, defaults to "5432"
- PSQL_DB: Database to backup
- PSQL_USERNAME: PSQL username
- PSQL_PASSWORD: PSQL password
- BUCKET_NAME: S3 bucket name
- S3CFG_PATH: S3 config file path, defaults to "$HOME/.s3cfg"
- S3_HOST_BASE: S3 host base, defaults to "ams3.digitaloceanspaces.com"
- S3_HOST_BUCKET: S3 host bucket, defaults to "%(bucket)s.ams3.digitaloceanspaces.com"
