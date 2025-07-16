terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


# Modulo ECR
module "ecr" {
  source     = "./modules/ecr"
  aws_region = var.aws_region
  repo_names = var.repo_names
}

# Modulo Networking
module "vpc" {
  source = "./modules/vpc"

  environment = var.environment
}

# Modulo IAM
module "iam" {
  source      = "./modules/iam"
  environment = var.environment
}

# Modulo CloudWatch
module "cloudwatch" {
  source      = "./modules/cloudwatch"
  environment = var.environment
}

# Modulo Service Discovery
module "service_discovery" {
  source = "./modules/service-discovery"

  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  service_configs  = {
    users     = { port = 8080, cpu = 256, memory = 512 }
    products  = { port = 8081, cpu = 256, memory = 512 }
    inventory = { port = 8082, cpu = 256, memory = 512 }
    orders    = { port = 8085, cpu = 256, memory = 512 }
  }
}

# Modulo ECS
module "ecs" {
  source = "./modules/ecs"

  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.subnet_ids
  security_group_id      = module.vpc.app_security_group_id
  repository_urls        = module.ecr.repository_urls
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  aws_region             = var.aws_region
  service_registry_arns  = module.service_discovery.service_registry_arns


  container_environment = {
    users = [
      # Database Configuration
      { name = "DB_HOST", value = split(":", module.rds.db_endpoint)[0] },
      { name = "DB_PORT", value = tostring(5432) },
      { name = "DB_NAME", value = var.db_name },
      { name = "DB_SCHEMA", value = var.db_schema },
      { name = "DB_USERNAME", value = var.db_username },
      { name = "DB_PASSWORD", value = var.db_password },
      # JWT Configuration
      { name = "JWT_SECRET_KEY", value = var.jwt_secret_key },
      { name = "JWT_EXPIRATION", value = var.jwt_expiration },
      { name = "JWT_REFRESH_TOKEN", value = var.jwt_refresh_token },
      # Service URLs
      { name = "PRODUCTS_SERVICE_URL", value = "http://products.${var.environment}.local:8081" },
      { name = "INVENTORY_SERVICE_URL", value = "http://inventory.${var.environment}.local:8082" },
      { name = "ORDERS_SERVICE_URL", value = "http://orders.${var.environment}.local:8085" },
      { name = "LAMBDA_NOTIFICATION_URL", value = module.lambda.lambda_invoke_arn }
    ],
    products = [
      # Database Configuration
      { name = "DB_HOST", value = split(":", module.rds.db_endpoint)[0] },
      { name = "DB_PORT", value = tostring(5432) },
      { name = "DB_NAME", value = var.db_name },
      { name = "DB_SCHEMA", value = var.db_schema },
      { name = "DB_USERNAME", value = var.db_username },
      { name = "DB_PASSWORD", value = var.db_password },
      # JWT Configuration
      { name = "JWT_SECRET_KEY", value = var.jwt_secret_key },
      { name = "JWT_EXPIRATION", value = var.jwt_expiration },
      { name = "JWT_REFRESH_TOKEN", value = var.jwt_refresh_token },
      # Service URLs
      { name = "USERS_SERVICE_URL", value = "http://users.${var.environment}.local:8080" },
      { name = "INVENTORY_SERVICE_URL", value = "http://inventory.${var.environment}.local:8082" },
      { name = "ORDERS_SERVICE_URL", value = "http://orders.${var.environment}.local:8085" },
      { name = "LAMBDA_NOTIFICATION_URL", value = module.lambda.lambda_invoke_arn }
    ],
    inventory = [
      # Database Configuration
      { name = "DB_HOST", value = split(":", module.rds.db_endpoint)[0] },
      { name = "DB_PORT", value = tostring(5432) },
      { name = "DB_NAME", value = var.db_name },
      { name = "DB_SCHEMA", value = var.db_schema },
      { name = "DB_USERNAME", value = var.db_username },
      { name = "DB_PASSWORD", value = var.db_password },
      # JWT Configuration
      { name = "JWT_SECRET_KEY", value = var.jwt_secret_key },
      { name = "JWT_EXPIRATION", value = var.jwt_expiration },
      { name = "JWT_REFRESH_TOKEN", value = var.jwt_refresh_token },
      # Service URLs
      { name = "USERS_SERVICE_URL", value = "http://users.${var.environment}.local:8080" },
      { name = "PRODUCTS_SERVICE_URL", value = "http://products.${var.environment}.local:8081" },
      { name = "ORDERS_SERVICE_URL", value = "http://orders.${var.environment}.local:8085" },
      { name = "LAMBDA_NOTIFICATION_URL", value = module.lambda.lambda_invoke_arn }
    ],
    orders = [
      # Database Configuration
      { name = "DB_HOST", value = split(":", module.rds.db_endpoint)[0] },
      { name = "DB_PORT", value = tostring(5432) },
      { name = "DB_NAME", value = var.db_name },
      { name = "DB_SCHEMA", value = var.db_schema },
      { name = "DB_USERNAME", value = var.db_username },
      { name = "DB_PASSWORD", value = var.db_password },
      # JWT Configuration
      { name = "JWT_SECRET_KEY", value = var.jwt_secret_key },
      { name = "JWT_EXPIRATION", value = var.jwt_expiration },
      { name = "JWT_REFRESH_TOKEN", value = var.jwt_refresh_token },
      # Service URLs
      { name = "USERS_SERVICE_URL", value = "http://users.${var.environment}.local:8080" },
      { name = "PRODUCTS_SERVICE_URL", value = "http://products.${var.environment}.local:8081" },
      { name = "INVENTORY_SERVICE_URL", value = "http://inventory.${var.environment}.local:8082" },
      { name = "LAMBDA_NOTIFICATION_URL", value = module.lambda.lambda_invoke_arn }
    ]
  }
}

# Modulo RDS
module "rds" {
  source = "./modules/rds"

  environment       = var.environment
  subnet_ids        = module.vpc.subnet_ids
  security_group_id = module.vpc.database_security_group_id
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = var.db_name
  db_schema         = var.db_schema
}

# SNS Topic para notificaciones
resource "aws_sns_topic" "email_notifications" {
  name = "${var.environment}-email-notifications"

  tags = {
    Name        = "${var.environment}-email-notifications"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Suscripción SNS para tu email
resource "aws_sns_topic_subscription" "email_notification" {
  topic_arn = aws_sns_topic.email_notifications.arn
  protocol  = "email"
  endpoint  = "carlosarroyave991@gmail.com"
}

# Modulo Lambda
module "lambda" {
  source = "./modules/lambda"

  environment      = var.environment
  function_name    = "email-sender"
  lambda_role_arn  = module.iam.lambda_execution_role_arn
  sendgrid_api_key = var.sendgrid_api_key
}

# OUTPUTS

# Exponer todos los outputs del módulo ECR
output "ecr_outputs" {
  description = "Todos los outputs del módulo ECR"
  value = {
    repository_urls = module.ecr.repository_urls
    repository_arns = module.ecr.repository_arns
    registry_id     = module.ecr.registry_id
  }
}
output "vpc_outputs" {
  description = "Todos los outputs del módulo de VPC"
  value = {
    vpc_id                     = module.vpc.vpc_id
    app_security_group_id      = module.vpc.app_security_group_id
    database_security_group_id = module.vpc.database_security_group_id
    subnet_ids                 = module.vpc.subnet_ids
  }
}

output "ecs_outputs" {
  description = "Todos los outputs del módulo ECS"
  value = {
    service_info = module.ecs.service_info
  }
}

output "lambda_outputs" {
  description = "Todos los outputs del módulo Lambda"
  value = {
    function_arn    = module.lambda.lambda_function_arn
    function_name   = module.lambda.lambda_function_name
    invoke_arn      = module.lambda.lambda_invoke_arn
  }
}


