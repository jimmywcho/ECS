module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  name    = "my-app-alb"
  vpc_id  = var.vpc_id
  subnets = var.public_subnets

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      protocol    = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "blue"
      }
    }
  }

  target_groups = {
    blue = { # blue = old version
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "ip"
      health_check: {
        path                = "/"
        interval            = 30
        timeout             = 10
        healthy_threshold   = 2
        unhealthy_threshold = 2
        port = "traffic-port"
      }
      create_attachment = false
    }

    green = { #green = new version
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "ip"
      health_check: {
        path                = "/"
        interval            = 30
        timeout             = 10
        healthy_threshold   = 2
        unhealthy_threshold = 2
        port = "traffic-port"
      }
      create_attachment = false
    }
  }
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"

  cluster_name = "my-fargate-cluster"

  services = {

    "my-app" = {
      cpu    = 256
      memory = 512

      subnet_ids = var.private_subnets
      force_new_deployment = false

      deployment_controller = {
        type = "CODE_DEPLOY"
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["blue"].arn
          container_name   = "web"
          container_port   = 80
        }
      }

      container_definitions = {
        "web" = {
          image = "$accountID.dkr.ecr.us-east-1.amazonaws.com/my-app:v1.0.0" #change your accountID and tag accordingly
          portMappings = [
            {
              containerPort = 80
              protocol      = "tcp"
              hostPort = 80
            }
          ]
          readonlyRootFilesystem = false
        }
      }
      cloudwatch_log_group_retention_in_days = 7

      security_group_ingress_rules = {
        alb_3000 = {
          description                  = "Service port"
          from_port                    = 80
          to_port                      = 80
          ip_protocol                  = "tcp"
          referenced_security_group_id = module.alb.security_group_id
        }
      }
      security_group_egress_rules = {
        all = {
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }
  }
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"

  repository_name = "my-app"

  repository_image_tag_mutability = "IMMUTABLE"

  repository_image_scan_on_push = true

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
