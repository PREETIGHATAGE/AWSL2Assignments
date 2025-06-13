#!/bin/bash

# -------- CONFIG --------
BUCKET="case-study2-s3"     # <- change if your bucket name is different
STACK_NAME="blue-green-stack"
REGION="us-east-1"

echo "Uploading templates to S3..."

aws s3 cp master-template.yaml s3://$BUCKET/ --region $REGION
aws s3 cp network/vpc-subnets.yaml s3://$BUCKET/network/ --region $REGION
aws s3 cp network/sg.yaml s3://$BUCKET/network/ --region $REGION
aws s3 cp alb/alb-blue.yaml s3://$BUCKET/alb/ --region $REGION
aws s3 cp alb/alb-blue-https-listener.yaml s3://$BUCKET/alb/ --region $REGION
aws s3 cp alb/alb-green-https-listener.yaml s3://$BUCKET/alb/ --region $REGION
aws s3 cp alb/alb-green.yaml s3://$BUCKET/alb/ --region $REGION
aws s3 cp asg/asg-blue.yaml s3://$BUCKET/asg/ --region $REGION
aws s3 cp asg/asg-green.yaml s3://$BUCKET/asg/ --region $REGION
aws s3 cp acm/ssl-cert.yaml s3://$BUCKET/acm/ --region $REGION
aws s3 cp route53/dns-weighted-routing.yaml s3://$BUCKET/route53/ --region $REGION

echo "Launching CloudFormation stack: $STACK_NAME"

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-url https://s3.amazonaws.com/$BUCKET/master-template.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --region $REGION

echo "Deployment started. Monitor stack in the AWS CloudFormation Console."