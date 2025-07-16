# Microservices Infrastructure with Terraform

Este proyecto despliega una arquitectura de microservicios en AWS usando Terraform.

## Arquitectura

- **ECS Fargate**: Contenedores para microservicios
- **RDS PostgreSQL**: Base de datos compartida
- **ECR**: Repositorios de imágenes Docker
- **Service Discovery**: AWS Cloud Map para comunicación entre servicios
- **Lambda**: Función para envío de emails
- **SNS**: Notificaciones por email

## Microservicios

- **Users** (Puerto 8080): Gestión de usuarios
- **Products** (Puerto 8081): Gestión de productos
- **Inventory** (Puerto 8082): Gestión de inventario
- **Orders** (Puerto 8085): Gestión de pedidos

## Requisitos

- Terraform >= 1.0
- AWS CLI configurado
- Docker
- Cuenta AWS con permisos apropiados

## Configuración

1. **Clonar el repositorio**
```bash
git clone <tu-repo>
cd terraform-test
```

2. **Configurar variables**
```bash
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores reales
```

3. **Inicializar Terraform**
```bash
terraform init
```

4. **Planificar despliegue**
```bash
terraform plan
```

5. **Aplicar cambios**
```bash
terraform apply
```

## Subir imágenes Docker

1. **Login a ECR**
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT-ID>.dkr.ecr.us-east-1.amazonaws.com
```

2. **Build y push**
```bash
docker build -t users .
docker tag users:latest <ACCOUNT-ID>.dkr.ecr.us-east-1.amazonaws.com/users:latest
docker push <ACCOUNT-ID>.dkr.ecr.us-east-1.amazonaws.com/users:latest
```

## Variables de Entorno

Cada microservicio recibe automáticamente:
- `SERVER_PORT`: Puerto específico del servicio
- `DB_*`: Configuración de base de datos
- `JWT_*`: Configuración JWT
- `*_SERVICE_URL`: URLs de otros microservicios
- `LAMBDA_NOTIFICATION_URL`: URL de la función Lambda

## Estructura del Proyecto

```
modules/
├── iam/                # Roles y permisos
├── ecr/                # Repositorios de imágenes
├── vpc/                # Networking y seguridad
├── ecs/                # Contenedores y servicios
├── rds/                # Base de datos
├── lambda/             # Funciones Lambda
├── cloudwatch/         # Logs y monitoreo
└── service-discovery/  # Service Discovery
```

## Limpieza

```bash
terraform destroy
```

## Notas de Seguridad

- Nunca subas `terraform.tfvars` al repositorio
- Las credenciales están en variables de entorno
- Los security groups limitan el acceso apropiadamente