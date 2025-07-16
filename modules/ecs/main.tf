# ECS Module - Cluster, Tasks y Services

# Cluster para definir el grupo logico donde corren los contenedores
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"

  tags = {
    Name        = "${var.environment}-ecs-cluster"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Task Definitions (una por servicio)
resource "aws_ecs_task_definition" "services" {
  for_each = var.service_configs
  
  family                   = "${var.environment}-${each.key}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = var.ecs_execution_role_arn


  container_definitions = jsonencode([
    {
      name  = each.key
      image = "${var.repository_urls[each.key]}:latest"
      environment = concat(
        var.container_environment[each.key],
        [{
          name  = "SERVER_PORT"
          value = tostring(each.value.port)
        }]
      )
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${var.environment}-${each.key}-logs"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = each.key
        }
      }

      portMappings = [
        {
          containerPort = each.value.port
          protocol      = "tcp"
        }
      ]      
    }
  ])

  tags = {
    Name        = "${var.environment}-${each.key}-task"
    Environment = var.environment
    Service     = each.key
  }
}

# ECS Services
resource "aws_ecs_service" "services" {
  for_each = var.service_configs
  
  name            = "${var.environment}-${each.key}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.services[each.key].arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  # Service Discovery
  dynamic "service_registries" {
    for_each = length(var.service_registry_arns) > 0 ? [1] : []
    content {
      registry_arn = var.service_registry_arns[each.key]
    }
  }

  tags = {
    Name        = "${var.environment}-${each.key}-service"
    Environment = var.environment
    Service     = each.key
  }
}


