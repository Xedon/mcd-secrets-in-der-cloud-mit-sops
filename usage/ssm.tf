data "sops_file" "secrets_ssm" {
  source_file = "secrets.json"
}

resource "aws_ssm_parameter" "secret" {
  name        = "api_key"
  description = "Api Key"
  type        = "SecureString"
  value       = data.sops_file.secrets_ssm.data["api_key"]
}
