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
    security_group_ids = list(string)
  })
}

variable "broker" {
  description = "Broker"
  type        = object({
    rabbitmq_username = string
    rabbitmq_password = string
  })
}