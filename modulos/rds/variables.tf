variable "identifier" {
  description = "Identificador da instância do banco de dados"
  type        = string
}

variable "engine" {
  description = "Engine do banco de dados"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Versão da engine"
  type        = string
  default     = "16"
}

variable "master_username" {
  description = "Nome de usuário master para o banco de dados"
  type        = string
}

variable "master_password" {
  description = "Senha do usuário master para o banco de dados"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Lista de IDs dos grupos de segurança do VPC"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Nome do grupo de subnets do banco de dados"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Pular snapshot final ao destruir o cluster"
  type        = bool
  default     = true
}

variable "instance_class" {
  description = "Classe da instância do banco de dados"
  type        = string
  default     = "db.t3.micro"
}

variable "publicly_accessible" {
  description = "Se a instância do banco de dados deve ser publicamente acessível"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Ambiente (ex: dev, prod)"
  type        = string
}

variable "local_machine_ip" {
  description = "IP da máquina local para acesso ao RDS"
  type        = string
}

variable "storage" {
  description = "Configuração de armazenamento"
  type        = object({
    type                  = string
    allocated             = number
    encrypted             = bool
    max_allocated_storage = number
  })
}

variable "apply_immediately" {
  description = "Aplicar as alterações imediatamente"
  type        = bool
  default     = false
}