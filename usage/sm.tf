data "sops_file" "secrets_sm" {
  source_file = "secrets.json"
}

resource "aws_secretsmanager_secret" "api_key" {
  name                    = "my_secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "api_key" {
  secret_id     = aws_secretsmanager_secret.api_key.id
  secret_string = data.sops_file.secrets_sm.data["api_key"]
}
