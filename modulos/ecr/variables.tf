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

variable "vpc_id" {
  description = "ID da VPC onde o repositório ECR será criado"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das subnets onde o repositório ECR será criado"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID do security group padrão da VPC"
  type        = string
}

variable "region" {
  description = "Região onde o repositório ECR será criado"
  type        = string
}