variable "sops_file_yaml_path" {
  type        = string
  description = "Filename with Path where the .sops.yaml gets stored"
  default     = "./sops.yaml"
}

variable "sops_folders_regex" {
  type        = set(string)
  description = "Path globs where the sops key gets used"
  default     = ["./*"]
}

variable "sops_key_user_group_role_name" {
  type        = string
  description = "User group/role name for AssumeRole to grant access to the key"
}


variable "sops_key_admin_group_role_name" {
  type        = string
  description = "User group/role name for AssumeRole to grant access to the key as Administrator"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags to apply to every created resource"
}
