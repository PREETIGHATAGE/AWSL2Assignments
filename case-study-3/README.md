# AWS L2 Assignments – Case Study 3

## Objective

This case study demonstrates how to:
- Monitor AWS account activity for unusual IAM behavior
- Configure security alerts via SNS when AccessDenied actions occur
- Set up cross-account access between EC2 in Account-A and S3 in Account-B
- Enforce IAM least privilege and consolidated billing with AWS Organizations

---

## Architecture

- AWS Organization with:
  - Management Account
  - Account-A: EC2 + CloudTrail + SNS
  - Account-B: S3 bucket for billing reports
- Cross-account IAM Role setup
- CloudTrail and CloudWatch for monitoring
- SNS for email alerts

---

## Tech Stack

- AWS Organizations
- AWS CloudTrail
- AWS CloudWatch Logs + Alarms
- AWS S3
- AWS SNS
- IAM (Least Privilege)
- EC2 (Amazon Linux 2)

---

## Steps Implemented

### Step 1: AWS Organization Setup
- Created org with full features enabled
- Invited Account-A and Account-B
- Enabled consolidated billing
- Configured billing alerts

### Step 2: S3 Setup in Account-B
- Created bucket: `case-study3-billing-reports`
- Enabled encryption (SSE-S3)
- Uploaded `sample.txt` for testing

### Step 3: IAM Role in Account-A
- Role: `EC2S3AccessRole`
- Attached policy:
  - `s3:GetObject`
  - `s3:PutObject`
  - `s3:ListBucket`
- Resource restricted to specific S3 bucket

### Step 4: EC2 Instance in Account-A
- Launched with IAM Role attached
- Verified CLI access to Account-B's S3 bucket

### Step 5: CloudTrail + SNS Alerts
- Trail: `CaseStudyTrail` with CloudWatch Logs
- Log group: `/cloudtrail/casestudy`
- SNS Topic: `SecurityAlerts` with email subscription
- Metric Filter: Captures `AccessDenied` errors
- Alarm: `AccessDeniedAlarm` triggers email via SNS

### Step 6: IAM Least Privilege
- IAM Role has only minimum permissions
- No wildcards or unnecessary services

---
