#!/bin/sh
OUTPUT_FILE=${DB_NAME}_$(date +"%m_%d_%Y-%H_%M_%S")_dump.tar

PGPASSWORD=${DB_PASSWORD} pg_dump -v -U ${DB_USERNAME} -h ${DB_HOST} -p ${DB_PORT} -W -F t ${DB_NAME} > ./${OUTPUT_FILE}

if [ "${?}" -eq 0 ]; then
  aws s3 cp ${OUTPUT_FILE} s3://${S3_BUCKET} \
    && rm ${OUTPUT_FILE}
else
  echo "Error backing up postgres"
  exit 1
fi