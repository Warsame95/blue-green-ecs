# URL Shortener on AWS ECS with Blue/Green Releases

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

<img width="2360" height="1423" alt="ecs v2" src="https://github.com/user-attachments/assets/0d3a373f-a7c6-443c-90e0-95c96d0a8faf" />


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


## Running the Application Locally

### Requirements

- Docker
- Docker Compose (v2)

### Setup Environment Variables

Create a `.env` file in the project root:

```bash
touch .env
```
Add the following variables:

```
AWS_REGION=eu-west-2
DYNAMODB_TABLE=my_db
```
### Start the Application

From app/, run:

```bash
docker compose up 
```
The application will be available at:

```
http://localhost:8080
```

### Stop the Application

```bash
docker compose down 
```

## CI/CD workflows
- **Build and Push to ECR**
<img width="1027" height="673" alt="Screenshot 2026-04-15 at 15 31 55" src="https://github.com/user-attachments/assets/c3a5d926-256a-4d41-9e57-d4c331b44e1c" />

- **Terraform Plan**
<img width="1030" height="662" alt="Screenshot 2026-04-15 at 15 42 19" src="https://github.com/user-attachments/assets/09685081-761b-4460-a029-54c627a97c36" />

- **Terraform Apply**
<img width="1082" height="545" alt="Screenshot 2026-04-15 at 15 56 06" src="https://github.com/user-attachments/assets/4feb914e-3c15-42fa-bae4-f5071498e686" />

- **Terraform Destroy**
<img width="1036" height="626" alt="Screenshot 2026-04-15 at 16 08 47" src="https://github.com/user-attachments/assets/9cdf6f00-cdda-4b00-ba44-bc2fb4f79b90" />

## Screenshots

<img width="1338" height="749" alt="Screenshot 2026-04-15 at 16 21 49" src="https://github.com/user-attachments/assets/5f9b832b-82ed-41ea-a930-4b5824adf652" />


