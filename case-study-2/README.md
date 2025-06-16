# AWS L2 Assignments - Case Study 2

# Project: AWS Blue/Green Deployment

This project implements a complete **Blue/Green Deployment architecture on AWS** using CloudFormation Nested Stacks.  
It follows best practices for zero-downtime deployments, ALB-based routing, ACM SSL automation, and Route53 weighted routing.

---
##  Features

- Fully automated Blue/Green Deployment using Nested CloudFormation Stacks
- Zero-downtime deployments with controlled traffic shifting
- Automatic ACM Certificate creation with DNS validation
- Automated Route53 weighted routing
- Modular, reusable, and parameterized YAML templates
- Single-click deployment via shell script (`deploy.sh`)
- Secure HTTPS traffic via ACM integration with ALB
- Auto Scaling Groups with Launch Templates for Blue and Green environments
- ALB health checks, Target Groups, and Security Groups properly configured
- Completely production-grade and interview-ready solution
---

## Services Used

- VPC
- Subnets (Public)
- Route Tables & Internet Gateway
- Security Groups
- Application Load Balancers (Blue & Green)
- Target Groups
- Auto Scaling Groups (ASG) with Launch Templates
- ACM (AWS Certificate Manager) with DNS Validation
- Route53 Weighted Routing (Blue/Green Traffic Shift)
- S3 (for CloudFormation template storage)
- CloudFormation Nested Stacks

---

##  Prerequisites

Before running this solution, ensure you have:

### 1. AWS Account

- AWS Account with Admin permissions

### 2. AWS CLI Installed & Configured

- Install AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
- Configure credentials:

```bash
aws configure
```

### 3. Domain Name (Highly Recommended)

- Purchase domain via Route53 (example: `myap123.com`)  
  This allows automatic DNS validation for ACM certificate.
- AWS Route53 hosted zone will automatically get created.

> **Note:** If you don’t purchase a domain, you’ll face ACM pending validation issue.

### 4. Create S3 Bucket

- Create an S3 bucket to store CloudFormation templates:

```bash
aws s3 mb s3://<your-s3-bucket-name>
```
---
## Deployment Steps

### 1. Modify `deploy.sh` Script

Update these variables in `deploy.sh` file:

```bash
BUCKET_NAME=<your-s3-bucket-name>
STACK_NAME=<your-cloudformation-stack-name>
```

### 2. Upload Templates and Deploy Master Stack

```bash
chmod +x deploy.sh
./deploy.sh
```

- Script will:
  - Upload templates to S3
  - Launch master CloudFormation stack
  - Deploy all nested stacks automatically

---

##  ACM DNS Validation Automation

- HostedZoneId passed in `params.json`
- ACM creates CNAME record in Route53 automatically (if domain registered inside Route53)
- Certificate status turns `Issued` automatically within a few minutes

---

## Post-Deployment Verification

### Validate ALB Blue:

```bash
http://blue-alb-xxxxxxxxxx.us-east-1.elb.amazonaws.com
```

### Validate ALB Green:

```bash
http://green-alb-xxxxxxxxxx.us-east-1.elb.amazonaws.com
```

### Validate Domain (after ACM validation success):

```bash
https://myap123.com
```

---

##  Blue/Green Traffic Switching (Weighted Routing)

- Go to AWS Console → Route53 → Hosted Zone → Weighted Records
- Modify weight (0% → 100%) to shift traffic between Blue and Green ASGs
- Allows zero-downtime deployment shifting

Example:

| Record | Blue | Green |
|--------|------|-------|
| Weighted Routing | 100% | 0% |
| Weighted Routing | 50% | 50% |
| Weighted Routing | 0% | 100% |

---

##  CloudFormation Stack Dependencies

- `master-template.yaml` controls nested stack order:
  - VPCStack → ACMStack → ALBBlueStack → ALBGreenStack → ASGBlueStack → ASGGreenStack → DNSRoutingStack

---

##  Clean-Up Resources (Avoid Unnecessary Charges)

To delete all resources after testing:

```bash
aws cloudformation delete-stack --stack-name <your-stack-name>
```

---
