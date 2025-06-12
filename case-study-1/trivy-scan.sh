#!/bin/bash

IMAGE_NAME=$1

if [ -z "$IMAGE_NAME" ]; then
  echo "Usage: ./trivy-scan.sh <docker-image>"
  exit 1
fi

trivy image --exit-code 1 --severity CRITICAL $IMAGE_NAME | tee evidence/trivy-scan-results.txt
