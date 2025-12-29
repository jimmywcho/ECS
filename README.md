# AWS ECS Fargate Infrastructure with Terraform

This project provisions a scalable and highly available infrastructure on AWS using Terraform. It sets up a VPC, an Application Load Balancer (ALB), and an ECS Cluster running a Fargate service.

## Architecture Overview

The infrastructure consists of the following components:

- **VPC Module**: Creates a Virtual Private Cloud with public and private subnets across multiple Availability Zones. It also includes a NAT Gateway for private subnet outbound connectivity.
- **ECS Module**: Sets up an AWS ECS Cluster using Fargate capacity providers.
- **ALB Module**: Provisions an Application Load Balancer to distribute incoming HTTP traffic to the ECS services.
- **Services Module**: Deploys an ECS Service (running Nginx by default) within the ECS cluster, integrated with the ALB.

## Project Structure

```text
.
├── main.tf            # Root Terraform configuration
├── outputs.tf         # Root level outputs
├── modules/
│   ├── network/       # VPC and networking configuration
│   │   ├── main.tf
│   │   └── outputs.tf
│   └── services/      # ECS, ALB, and Service definitions
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md          # Project documentation
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0+)
- AWS CLI configured with appropriate credentials.

## Deployment

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **View Execution Plan**:
   ```bash
   terraform plan
   ```

3. **Apply Changes**:
   ```bash
   terraform apply
   ```

## Infrastructure Details

- **Region**: `us-east-1` (default)
- **ECS Cluster Name**: `my-fargate-cluster`
- **Service**: Nginx (latest)
- **Networking**:
  - VPC CIDR: `10.0.0.0/16`
  - 3 Public Subnets
  - 3 Private Subnets
  - Single NAT Gateway

## Outputs

After a successful `terraform apply`, the following outputs will be available (depending on your `outputs.tf` configuration):

- `vpc_id`: The ID of the created VPC.
- `alb_dns_name`: The DNS name of the Application Load Balancer to access the service.
