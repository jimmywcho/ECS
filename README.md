# AWS ECS Fargate Infrastructure with Terraform

This project provisions a scalable and highly available infrastructure on AWS using Terraform. It sets up a VPC, an Application Load Balancer (ALB), an ECR repository, and an ECS Cluster running a Fargate service with Blue/Green deployment capabilities via CodeDeploy.

## Architecture Overview

The infrastructure consists of the following components:

- **VPC Module**: Creates a Virtual Private Cloud with public and private subnets across multiple Availability Zones. It also includes a NAT Gateway for private subnet outbound connectivity.
- **ECS Module**: Sets up an AWS ECS Cluster using Fargate capacity providers.
- **ALB Module**: Provisions an Application Load Balancer to distribute incoming HTTP traffic to the ECS services (supports Blue and Green target groups).
- **ECR Module**: Creates an Elastic Container Registry for storing Docker images.
- **CodeDeploy**: Manages Blue/Green deployments for the ECS service, allowing for zero-downtime updates and easy rollbacks.

## Project Structure

```text
.
├── main.tf            # Root Terraform configuration
├── outputs.tf         # Root level outputs
├── image.sh           # Reference script for building and pushing images (not for direct use)
├── Dockerfile         # Dockerfile for the application
├── index.html         # Sample application content
├── deployment/        # CodeDeploy configuration files
│   ├── appspec.yaml
│   └── taskdef.json
├── modules/
│   ├── network/       # VPC and networking configuration
│   │   ├── main.tf
│   │   └── outputs.tf
│   └── services/      # ECS, ALB, ECR, and CodeDeploy definitions
│       ├── main.tf
│       ├── codedeploy.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md          # Project documentation
```

## ⚠️ Important Configuration

Before deploying, you **must** update the AWS Account ID in the following file:

1.  **`modules/services/main.tf`**: Update the `image` path in the `container_definitions` (line ~96) from `$accountID` to your actual AWS Account ID.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0+)
- AWS CLI configured with appropriate credentials.
- Docker installed (for building and pushing images).

## Deployment Steps

1.  **Build and Push Docker Image**:
    You need to build and push your Docker image to the ECR repository created by Terraform. You can use the `image.sh` file as a reference for the required commands, but do not run it directly as it is an incomplete template.

2.  **Initialize Terraform**:
    ```bash
    terraform init
    ```

3.  **Deploy Infrastructure**:
    ```bash
    terraform apply
    ```

## Infrastructure Details

- **Region**: `us-east-1` (default)
- **ECS Cluster Name**: `my-fargate-cluster`
- **Deployment Strategy**: Blue/Green (CodeDeploy)
- **Networking**:
    - VPC CIDR: `10.0.0.0/16`
    - 3 Public Subnets / 3 Private Subnets
    - Single NAT Gateway

## Outputs

After a successful `terraform apply`, the following outputs will be available:

- `vpc_id`: The ID of the created VPC.
- `alb_dns_name`: The DNS name of the Application Load Balancer to access the service.
