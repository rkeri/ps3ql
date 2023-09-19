#!/bin/bash

set -e

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

checkForVariable() {
    if [[ -z ${!1+set} ]]; then
       echo "${RED}Error: $1 environment variable is not defined, aborting backup${NC}"
       exit 1
    fi
}

if [[ -z $S3_ACCESS_KEY || -z $S3_SECRET_KEY ]]; then
    echo "${YELLOW}Warning! S3_ACCESS_KEY and/or S3_SECRET_KEY is unset!${NC}"
else
    echo "Setting access_key and secret_key in $S3CFG_PATH"
    envsubst < s3cfg-default > $S3CFG_PATH
fi

BACKUP_NAME="${PSQL_BACKUP_NAME}_$(date +%s)"

checkForVariable PSQL_ADDRESS
checkForVariable PSQL_PORT
checkForVariable PSQL_DB
checkForVariable PSQL_USERNAME
checkForVariable PSQL_PASSWORD
checkForVariable BUCKET_NAME

export PGPASSWORD=$PSQL_PASSWORD

echo "Creating database dump..."

pg_dump -v -h $PSQL_ADDRESS -p $PSQL_PORT -d $PSQL_DB -U $PSQL_USERNAME -f $BACKUP_NAME

echo "Zipping backup..."

gzip -v $BACKUP_NAME

echo "Uploading backup to s3..."

s3cmd --verbose --no-check-certificate --config $S3CFG_PATH put $BACKUP_NAME.gz s3://$BUCKET_NAME

echo "Backup finished" && exit 0
