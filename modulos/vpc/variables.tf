variable "project_name" {
  description = "Nome do projeto para ser usado nos recursos"
  type        = string
}

variable "environment" {
  description = "Dev/Prod, usado nos recursos AWS para compor tags e nomes dos recursos"
  type        = string
}

variable "availability_zones" {
  description = "Zonas de disponibilidade para as subnets"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Blocos CIDR para as subnets públicas"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Blocos CIDR para as subnets privadas"
  type        = list(string)
}


