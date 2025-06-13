#!/bin/bash
apt update -y
apt install -y awscli unzip curl

LOG_FILE="/var/log/s3-fetch.log"
BUCKET_NAME=${BUCKET_NAME}

mkdir -p /tmp/s3-files

echo "[`date`] listing files from S3 buckey: $BUCKET_NAME" >> $LOG_FILE
aws s3 ls s3://$BUCKET_NAME/ >> $LOG_FILE 2>&1

echo "[`date`] Downloading files to /tmp/s3-files/" >> $LOG_FILE
aws s3 cp s3://$BUCKET_NAME/  /tmp/s3-files/ --recursive  --region us-east-1 >> $LOG_FILE 2>&1

echo "[`date`] Download complete.Listing downloaded files:" >> $LOG_FILE
ls -lh /tmp/s3-files/  >> $LOG_FILE 2>&1 