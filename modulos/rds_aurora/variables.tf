variable "cluster_identifier" {
  description = "Identificador do cluster RDS"
  type        = string
}

variable "engine" {
  description = "Engine do banco de dados"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Versão do engine do Aurora PostgreSQL"
  type        = string
  default     = "11.9"
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

variable "backup_retention_period" {
  description = "Período de retenção de backup em dias"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Janela de backup preferida"
  type        = string
  default     = "07:00-09:00"
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

variable "instance_count" {
  description = "Número de instâncias no cluster"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "Classe da instância do banco de dados"
  type        = string
  default     = "db.r5.large"
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