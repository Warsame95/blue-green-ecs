# URL Shortener on AWS ECS

This project is a production-style URL shortener application built with FastAPI, containerised with Docker, and deployed on Amazon ECS Fargate using Terraform.
The platform was designed to reflect real-world cloud engineering practices, with a strong focus on secure networking, repeatable infrastructure, and zero-downtime deployments.
It includes blue/green deployments, private networking with VPC endpoints, and AWS WAF protection in front of the load balancer.

### Project Overview

- **Terraform** provisions all AWS infrastructure as code for consistent, repeatable deployments
- **Amazon ECS Fargate** runs the containerised FastAPI application without managing servers
- **Blue/Green deployments** provide safer releases with near zero-downtime traffic switching
- **Application Load Balancer (ALB)** handles HTTPS traffic routing across target groups
- **AWS WAF** protects the public entry point from common web threats and unwanted traffic
- **Amazon CloudWatch Logs** captures container logs for troubleshooting and visibility
- **Amazon DynamoDB** stores URL mappings with low-latency serverless persistence
- **VPC Endpoints** provide private access to ECR, CloudWatch Logs, S3, and DynamoDB without using a NAT Gateway
- **OIDC authentication** enables secure CI/CD access to AWS without long-lived IAM credentials
- **Multi-stage Docker builds** reduce final image size and improve deployment efficiency
- **Amazon ECR** stores versioned container images used during deployments


## Architecture Diagram

<img width="2460" height="1423" alt="ecs v2" src="https://github.com/user-attachments/assets/244e66e2-7baa-49ad-abf5-b74dac92abba" />

## Project Structure

```text
blue-green-ecs/
├── .github/workflows/
│   ├── deploy.yaml
│   ├── terraform-plan.yaml
│   ├── terraform-apply.yaml
│   └── terraform-destroy.yaml
├── app/
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   └── compose.yaml
├── infra/
│   ├── modules/
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── .gitignore
└── README.md

```

## Design Choices

### Blue/Green Deployment Strategy

Native ECS blue/green deployments were chosen to reduce release risk and minimise downtime. New versions are deployed to an inactive environment before production traffic is shifted.

### VPC Endpoints Instead of NAT Gateway

VPC Endpoints were used to allow private access to ECR, CloudWatch Logs, S3, and DynamoDB without internet egress. This reduces cost and keeps service traffic within the AWS network.

### DynamoDB for URL Storage

DynamoDB was selected because the application mainly performs simple key-value lookups between short codes and original URLs. It provides low-latency performance, automatic scaling, and no database server management.
