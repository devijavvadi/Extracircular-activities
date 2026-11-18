# --- 11 Amazon ECR Repositories ---
resource "aws_ecr_repository" "repos" {
  for_each             = toset(var.ecr_repositories)
  name                 = "${var.project_name}-${var.environment}/${each.value}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-${each.value}"
  }
}

# --- Auto-Generated RDS MySQL Password ---
resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# --- AWS Secrets Manager for Database Credentials ---
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.project_name}/${var.environment}/rds-mysql-credentials"
  recovery_window_in_days = 0 # Allows clean deletion in dev/lab environments

  tags = {
    Name = "${var.project_name}-${var.environment}-db-secret"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_password.result
    engine   = "mysql"
    port     = 3306
  })
}
