# AWS L2 Assignments - Case Study 1

## Project: Currency Exchange Microservice CI/CD Pipeline

This project implements end-to-end CI/CD pipeline automation for a Spring Boot-based Currency Exchange microservice using Jenkins, Docker, SonarQube, Trivy, EKS, and AWS services.

---

## CI/CD Pipeline Workflow

1. **Build Stage**
    - Maven used to build the Spring Boot application (`mvn clean package -DskipTests`).
  
2. **Unit Testing Stage**
    - Unit tests executed using Maven Surefire plugin (`mvn test`).

3. **Static Code Analysis Stage**
    - SonarQube performs code quality and security scanning.
  
4. **Docker Build & Tag Stage**
    - Docker image is built using provided `Dockerfile` and tagged with build number.

5. **Vulnerability Scanning Stage**
    - Trivy scans Docker image for vulnerabilities.
  
6. **Push Image to AWS ECR Stage**
    - Docker image pushed to AWS Elastic Container Registry.

7. **Kubernetes Deployment Stage**
    - Application deployed to AWS EKS using respective environment `deployment.yaml` files.

8. **Approval & Production Deployment**
    - Manual approval step implemented for production deployment.

---

## Tools & Technologies Used

| Tool            | Purpose                          |
|------------------|-----------------------------------|
| Jenkins          | CI/CD Pipeline Orchestration     |
| Maven            | Build & Unit Test Management     |
| SonarQube        | Static Code Analysis             |
| Trivy            | Vulnerability Scanning           |
| Docker           | Containerization                 |
| AWS ECR          | Docker Image Registry            |
| AWS EKS          | Kubernetes Cluster Management    |
| kubectl          | Deployment Automation            |

---

## Pre-Requisites

- AWS Account
- Jenkins Server
- SonarQube Server
- AWS CLI & IAM Role
- Kubernetes Cluster (AWS EKS)
- Docker Installed on Jenkins Node
- Trivy Installed on Jenkins Node

---

 **Assignment fully implemented as per Case Study-1 requirements.**  
 **Proper folder structure maintained for production-ready projects.**

---
