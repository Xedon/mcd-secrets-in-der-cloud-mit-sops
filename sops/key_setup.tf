data "aws_iam_policy_document" "repository_key" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM policies"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.kms_admin_role.arn]
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow access for Key users"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.repository_key_user_role.arn]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}

resource "aws_kms_key" "terraform_repository_key" {
  description             = "Key for Sops credentials en/de-cryption"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.repository_key.json
  tags                    = var.tags
}
