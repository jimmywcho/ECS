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
        target_group_key = "ecs-app"
      }
    }
  }

  target_groups = {
    ecs-app = {
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

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["ecs-app"].arn
          container_name   = "web"
          container_port   = 80
        }
      }

      container_definitions = {
        "web" = {
          image = "nginx:latest"
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