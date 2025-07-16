# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

# PostgreSQL RDS - FREE TIER
resource "aws_db_instance" "postgres" {
  identifier = "${var.environment}-postgres"
  
  # PostgreSQL FREE TIER
  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"  # FREE TIER
  
  # Storage FREE TIER
  allocated_storage = 20          # FREE TIER: 20GB
  storage_type     = "gp2"
  
  # Database
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible    = false
  
  # FREE TIER settings
  backup_retention_period = 0     # Sin backups para FREE TIER
  skip_final_snapshot    = true   # Para desarrollo
  deletion_protection    = false  # Para poder eliminar
  
  tags = {
    Name = "${var.environment}-postgres"
  }
}

