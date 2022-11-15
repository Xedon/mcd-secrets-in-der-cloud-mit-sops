terraform {
  required_version = "> 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}



module "sops" {
  source                         = "../sops"
  sops_file_yaml_path            = "../sops.yaml"
  sops_folders_regex             = ["usage"]
  sops_key_admin_group_role_name = "SopsAdminRole"
  sops_key_user_group_role_name  = "SopsUserRole"
}
