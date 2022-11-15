output "SOPS_KMS_ARN" {
  value = "${aws_kms_key.terraform_repository_key.arn}+${aws_iam_role.repository_key_user_role.arn}"
}

output "admin_group_name" {
  value = aws_iam_group.kms_admin_group.name
}

output "user_group_name" {
  value = aws_iam_group.repository_key_user_group.name
}
