variable "create_ecr" {
  description = "Booleano para criar ou não o repositório ECR"
  type        = bool
  default     = true
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "repository_sufix_name" {
  description = "Sufixo do nome do repositório"
  type        = string
}