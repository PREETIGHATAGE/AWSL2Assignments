# AWS L2 Assignments - Case Study 4

---

## Features Implemented

- Fully automated provisioning using Terraform
- Highly available architecture (3 subnets in different AZs)
- Docker installed automatically via UserData
- Secure S3 access using IAM Role (no credentials stored)
- S3 bucket mounted using `s3fs`
- Automatic test file created to verify mount
- Clean destruction using `force_destroy` for S3 bucket

---

## Prerequisites

- AWS Account with sufficient permissions
- AWS CLI configured
- Terraform installed (`>=1.5.x`)
- Ubuntu AMI ID for your region
- SSH Key Pair to connect to EC2 instances

---

## Tech Stack Used

- AWS (VPC, EC2, S3, IAM)
- Terraform (Infrastructure Automation)
- Bash (User Data script automation)
- s3fs-fuse (S3 mounting)
- Docker

---

## Architecture Overview

- 1 VPC with CIDR `10.0.0.0/16`
- 3 Public Subnets distributed across 3 different AZs
- Internet Gateway attached
- Route Table configured for internet access
- 3 EC2 Instances (Ubuntu, t2.micro)
- Security Group with SSH (port 22) allowed
- IAM Role attached to EC2 for secure S3 access
- S3 bucket mounted on EC2 at `/mnt/s3bucket` using `s3fs`

---

## User Data Automation (High-Level Steps)

- Update system packages
- Install Docker and `s3fs`
- Start and enable Docker service
- Configure FUSE (`/etc/fuse.conf`) to allow `allow_other`
- Create mount directory `/mnt/s3bucket`
- Mount S3 bucket using `s3fs` with IAM role authentication
- Write test file (`hello-from-ec2.txt`) into S3 bucket to verify mount

---

## Verification Steps

- SSH into EC2 instance using key pair
- Run:
  ```bash
  mount | grep s3fs
  ls /mnt/s3bucket
  cat /mnt/s3bucket/hello-from-ec2.txt
