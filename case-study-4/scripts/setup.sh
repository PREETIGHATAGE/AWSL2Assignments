#!/bin/bash 
apt-get update -y 
apt-get install -y docker.io s3fs

systemctl start docker
systemctl enable docker

echo "user_allow_other" | tee -a /etc/fuse.conf

mkdir -p /mnt/s3bucket

echo "Mounting S3 bucket: ${BUCKET_NAME} using IAM Role..." 
s3fs ${BUCKET_NAME} /mnt/s3bucket -o iam_role=auto -o allow_other -o use_path_request_style -o url=https://s3.amazonwas.com -o nonempty

chown ubuntu:ubuntu /mnt/s3bucket

echo "Hello from EC2! Successfully mounted using IAM Role." | sudo tee /mnt/s3bucket/hello-from-ec2.txt