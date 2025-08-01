terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "aws-infra/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-terraform-locks"
  }
}