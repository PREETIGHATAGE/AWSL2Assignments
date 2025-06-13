#!/bin/bash
BUCKET_NAME="case-study5-s3"
OUT_FOLDER="out"
COUNT_FOLDER="count"
TMP_DIR="/tmp/s3-wordcount"
COUNT_FILE="$TMP_DIR/count.txt"
LOG_FILE="/var/log/word-count.log"

mkdir -p $TMP_DIR
cd $TMP_DIR
> $COUNT_FILE

aws s3 ls s3://$BUCKET_NAME/$OUT_FOLDER/ |
awk '{print $4}' | grep '\.txt$' >files.txt

while read FILE; do
  echo "Processing: $FILE" | tee -a $LOG_FILE
  aws s3 cp s3://$BUCKET_NAME/$OUT_FOLDER/$FILE $FILE
  WORDS=$(wc -W <$FILE)
  TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "$TIMESTAMP - $FILE - $WORDS words" >> $COUNT_FILE
done < files.txt

aws s3 cp $COUNT_FILE s3://$BUCKET_NAME/$COUNT_FOLDER/count.txt