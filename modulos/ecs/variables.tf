variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Dev/Prod, usado nos recursos AWS para compor tags e nomes dos recursos"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o cluster ECS será criado"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das subnets onde o cluster ECS será criado"
  type        = list(string)
}

variable "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
  default     = "ecs-cluster"
}

variable "container_image_url" {
  description = "URL da imagem do container"
  type        = string
}

variable "ecs_params" {
  description = "Parâmetros do ECS"
  type = object({
    app_name         = string
    container_name   = string
    container_port   = number
    memory           = string
    cpu              = string
    desired_capacity = number
  })
}