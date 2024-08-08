variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente do projeto"
  type        = string
}

variable "vpc" {
  description = "VPC"
  type        = object({
    security_group_id  = string
    db_subnet_group_name = string
  })
}

variable "database" {
  description = "Banco de dados"
  type        = object({
    username = string
    password = string
  })
}

variable "instance" {
  description = "Instância"
  type        = object({
    name                = string
    class               = string
    publicly_accessible = bool
  })
}