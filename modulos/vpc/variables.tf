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

variable "db_subnet_cidrs" {
  description = "Blocos CIDR para as subnets do banco de dados"
  type        = list(string)
}

variable "local_machine_ip" {
  description = "IP da máquina local para permitir acessos externos"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Habilitar VPN Gateway"
  type        = bool
  default     = true
}

variable "create_database_subnet_group" {
  description = "Criar grupo de subnets para o banco de dados"
  type        = bool
  default     = false
}

variable "create_database_subnet_route_table" {
  description = "Criar tabela de roteamento para as subnets do banco de dados"
  type        = bool
  default     = false
}

variable "create_database_internet_gateway_route" {
  description = "Criar rota para a internet para as subnets do banco de dados"
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "Habilitar DNS hostnames"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Habilitar DNS support"
  type        = bool
  default     = true
}