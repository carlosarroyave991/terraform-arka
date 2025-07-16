# Networking Module - VPC y Security Groups

# VPC por defecto (GRATIS)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group para aplicaciones genera nombres unicos
resource "aws_security_group" "app" {
  name_prefix = "${var.environment}-app-"
  vpc_id      = data.aws_vpc.default.id
  description = "Security group para aplicaciones"

  # Users service - Puerto 8080
  ingress {
    description = "Users service"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Products service - Puerto 8081
  ingress {
    description = "Products service"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inventory service - Puerto 8082
  ingress {
    description = "Inventory service"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Orders service - Puerto 8085
  ingress {
    description = "Orders service"
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-app-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Security Group para base de datos
resource "aws_security_group" "database" {
  name_prefix = "${var.environment}-db-"
  vpc_id      = data.aws_vpc.default.id
  description = "Security group para base de datos"

  # PostgreSQL solo desde aplicaciones
  ingress {
    description     = "PostgreSQL from app"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  tags = {
    Name        = "${var.environment}-db-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}