# Foodie Platform Engineering

## Overview

Foodie Platform Engineering is a demo project that combines **AWS infrastructure provisioning with Terraform** and **container deployment automation with GitHub Actions**. The repository includes a small **Node/Vite frontend app** packaged in Docker, deployed to **Amazon ECS Fargate** behind an **Application Load Balancer (ALB)**.

This project is a practical example of modern DevOps and GitOps practices, showing how to:

- Define cloud infrastructure as code with Terraform
- Use AWS OIDC for secure GitHub Actions authentication
- Build and push Docker images into Amazon ECR
- Deploy updates to Amazon ECS Fargate
- Validate deployments with automated smoke tests

---

## What This Project Demonstrates

- Infrastructure as Code with **Terraform**
- Secure CI/CD using **GitHub Actions** and **AWS OIDC**
- Container image build and push to **Amazon ECR**
- Application deployment on **Amazon ECS Fargate**
- Application load balancing with **AWS ALB**
- Infrastructure state management using **S3 + DynamoDB**
- Security scanning with **Gitleaks** and **Snyk**
- Runtime observability via **CloudWatch Logs** and a New Relic sidecar

---

## Architecture

The project infrastructure includes:

- **AWS VPC** with public subnets
- **Application Load Balancer (ALB)** for external HTTP traffic
- **ECS Cluster** running a Fargate service
- **ECS Task Definition** for the Foodie app container and a New Relic sidecar
- **ECR Repository** for Docker image storage
- **IAM roles and policies** for GitHub Actions, ECS, and ECR
- **Terraform remote state** stored in S3 with DynamoDB locking

High-level flow:

1. Code pushed to `main`
2. GitHub Actions builds Docker image and pushes to ECR
3. GitHub Actions updates ECS task definition with the new image
4. ECS service rolls out the new task revision
5. Smoke test validates the application endpoint

---

## Tools & Technologies Used

| Tool / Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| GitHub Actions | CI/CD pipeline |
| AWS ECS Fargate | Container runtime |
| AWS ECR | Docker image registry |
| AWS ALB | Load balancing |
| AWS CloudWatch | Logging |
| Docker | Build and package application |
| Node.js / Vite | Frontend web app |
| Nginx | Static content hosting in container |
| Gitleaks | Secret scanning |
| Snyk | Dependency security scanning |
| Bash | Smoke test scripting |

---

## Project Structure

```text
foodie-platform-engineering/
├── .github/
│   └── workflows/
│       └── pipeline.yml          # GitHub Actions build + deploy pipeline
├── app/                          # Node/Vite frontend application
│   ├── index.html
│   ├── package.json
│   ├── src/
│   └── styles.css
├── infra/                        # Terraform infrastructure code
│   ├── alb.tf
│   ├── autoscaling.tf
│   ├── backend.tf
│   ├── ecr.tf
│   ├── ecs.tf
│   ├── iam.tf
│   ├── oidc.tf
│   ├── provider.tf
│   ├── security.tf
│   ├── vpc.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── nginx.conf                    # NGINX config for the container image
├── Dockerfile                    # Multi-stage Docker build for app image
├── tests/
│   ├── smoke-test.sh             # Post-deploy smoke test
│   └── load-test.js              # Load testing script
│
├── screenshots/                  # Project screenshots
│   ├── 01-github-actions-pipeline-success.png
│   ├── 02-ecs-service-healthy.png
│   ├── 03-alb-target-group-healthy.png
│   ├── 04-foodie-live-application.png
│   ├── 05-newrelic-observability-dashboard.png
│   ├── 06-app-homepage.png
│   └── 07-app-login-page.png
│
│
└── README.md                     # Project overview and instructions
```

---

## How the Automation Works

### GitHub Actions Pipeline

The single pipeline defined in `.github/workflows/pipeline.yml` performs two main jobs:

1. **build**
   - checks out repository code
   - generates image version tags
   - configures AWS credentials via GitHub OIDC and AssumeRole
   - scans the repo with **Gitleaks**
   - runs **Snyk** against the frontend app dependencies
   - builds the Docker image
   - tags and pushes the image to Amazon ECR

2. **deploy**
   - checks out repository code again
   - configures AWS credentials via GitHub OIDC
   - fetches the existing ECS task definition
   - replaces the container image with the newly pushed image
   - registers a new ECS task definition revision
   - updates the ECS service to use the new revision
   - waits for the deployment to stabilize
   - runs the smoke test against the configured application URL

### Infrastructure Provisioning

The `infra/` directory defines the AWS infrastructure for this project. It includes:

- VPC, public subnets, and routing
- ALB and target group configuration
- ECS cluster, service, and task definition
- ECR repository and lifecycle policy
- IAM roles and policies for OIDC and ECS task execution
- CloudWatch Logs group for ECS logging

The pipeline itself deploys application updates. Infrastructure provisioning is managed via Terraform in the `infra/` directory.

---

## Security & Best Practices

- GitHub Actions authenticates to AWS using **OIDC** rather than long-lived IAM keys
- Terraform remote state is stored in **S3** and locked with **DynamoDB**
- No AWS credentials are hard-coded in the repository
- The pipeline scans for secrets with **Gitleaks** and dependency risks with **Snyk**
- ECS containers are deployed with versioned image tags for traceability

---

## Prerequisites

- AWS account with permissions to create ECS, ECR, IAM, ALB, VPC, CloudWatch, S3, and DynamoDB resources
- GitHub repository configured with OIDC and pipeline secrets
- Docker installed locally for image build and testing
- Node.js installed for local app development

---

## Setup

### Local Application Development

```bash
cd app
npm install
npm run dev
```

### Build the Production App

```bash
cd app
npm run build
```

### Build the Docker Image Locally

```bash
docker build -t foodie-app:latest .
```

### Terraform Infrastructure

```bash
cd infra
terraform init
terraform plan -out plan.tfplan
terraform apply plan.tfplan
```

> Note: The backend is configured in `infra/backend.tf` to use an S3 bucket and DynamoDB table for state storage.

---

## GitHub Actions Configuration

The pipeline expects the following repository-level configuration:

### GitHub Variables
- `AWS_REGION`
- `ECR_REPOSITORY`
- `PIPELINE_SMOKE_TEST_URL`

### GitHub Secrets
- `AWS_ROLE_ARN`
- `ECS_CLUSTER_NAME`
- `ECS_SERVICE_NAME`
- `SNYK_TOKEN`

The workflow also depends on the OIDC role and policies defined in the Terraform configuration.

---

## Verifying the Deployment

After deployment, use Terraform outputs or the ALB DNS name to verify the application.

```bash
cd infra
terraform output alb_url
```

Open the returned URL in a browser. The smoke test script in `tests/smoke-test.sh` verifies that the application responds with basic HTML content.

---

## Cleanup

To avoid unnecessary AWS charges, destroy the infrastructure when it is no longer needed:

```bash
cd infra
terraform destroy
```

If the GitHub Actions workflow created AWS resources, ensure they are cleaned up or manually deleted from the AWS Console.

---

## Conclusion

This repo is a complete example of an AWS container deployment workflow using Terraform and GitHub Actions. It demonstrates how to keep infrastructure and deployment automation in code while applying security best practices such as OIDC authentication, state locking, and automated scanning.
