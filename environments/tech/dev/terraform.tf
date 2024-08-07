terraform {
  backend "s3" {
    bucket  = "terraform-fiap-4soat-g48-acafl"
    key     = "tc/dev/infra"
    region  = "us-east-1"
    profile = "4soat_g48"
  }
}