resource "aws_iam_policy" "allow_kms_key_listing_policy" {
  description = "Allow KMS listing of Keys"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "tag:GetResources",
          "kms:ListAliases"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "kms_admin_group_policy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Resource" : [
          "${aws_iam_role.kms_admin_role.arn}"
        ]
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_group" "kms_admin_group" {
  name = var.sops_key_admin_group_role_name
}

resource "aws_iam_group_policy_attachment" "kms_admin_group__policy" {
  policy_arn = aws_iam_policy.kms_admin_group_policy.arn
  group      = aws_iam_group.kms_admin_group.id
}

data "aws_iam_policy_document" "kms_admin_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "kms_admin_role" {
  name                = var.sops_key_admin_group_role_name
  managed_policy_arns = [aws_iam_policy.allow_kms_key_listing_policy.arn]
  assume_role_policy  = data.aws_iam_policy_document.kms_admin_assume_role_policy.json
  tags                = var.tags
}

resource "aws_iam_policy" "repository_key_user_group_policy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Resource" : [
          "${aws_iam_role.repository_key_user_role.arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_group" "repository_key_user_group" {
  name = var.sops_key_user_group_role_name
}

resource "aws_iam_group_policy_attachment" "repository_key_user_group_policy" {
  policy_arn = aws_iam_policy.repository_key_user_group_policy.arn
  group      = aws_iam_group.repository_key_user_group.id
}

data "aws_iam_policy_document" "repository_key_user_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "repository_key_user_role" {
  name               = var.sops_key_user_group_role_name
  assume_role_policy = data.aws_iam_policy_document.repository_key_user_assume_role_policy.json
  tags               = var.tags
}
