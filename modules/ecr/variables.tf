variable "repo_names" {
  description = "Nombres de los repositorios ECR a crear"
  type        = list(string)
}

variable "aws_region" {
  description = "Región AWS donde se crearán los repos"
  type        = string
}
