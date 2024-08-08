# variavel com a informação da conta
variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "profile" {
  type        = string
  description = "AWS Profile"
}

variable "rds_params" {
  type = object({
    master_username  = string
    master_password  = string
    database_name    = string
    local_machine_ip = string
  })
  description = "RDS Parameters"
}

variable "mongo_params" {
  type = object({
    database = object({
      username = string
      password = string
    })
  })
  description = "MongoDB Parameters"
}

variable "rabbitmq_params" {
  type = object({
    broker = object({
      rabbitmq_username = string
      rabbitmq_password = string
    })
  })
  description = "RabbitMQ Parameters"
}