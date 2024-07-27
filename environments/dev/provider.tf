
# definiçao do provedor AWS e a região onde serão aplicados os demais comandos
provider "aws" {
  profile = "4soat_g48"
  region  = "us-east-1"
  default_tags {
    tags = local.aws_default_tags
  }
}