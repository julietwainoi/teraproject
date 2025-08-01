resource "aws_ecr_repository" "main" {
  name = var.repository_name
  tags = {
    Name = var.repository_name
  }
}