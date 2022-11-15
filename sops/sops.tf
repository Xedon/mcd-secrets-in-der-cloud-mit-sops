resource "local_file" "sops_yaml" {
  filename = var.sops_file_yaml_path
  content = yamlencode({
    creation_rules = [
      for ex in var.sops_folders_regex : {
        path_regex = ex
        kms        = "${aws_kms_key.terraform_repository_key.arn}+${aws_iam_role.repository_key_user_role.arn}"
    }]
  })
}
