variable "openstack_user_name" {}
variable "openstack_tenant_name" {}
variable "openstack_password" {}
variable "openstack_auth_url" {}

variable "count" {
  default = "3"
}

variable "Network_name" {
  description = "The network to be used."
  default     = "Terraform"
}

variable "Key_Pair" {
  description = "The keypair to be used."
  default     = "JC_LT_Key"
}

variable "Name_Prefix" {
  default = "JC-RH"
}

variable "SG_Prefix" {
  default = "JC-SG"
}

variable "Instance_Type" {
  default = "m1.large"
}

variable "Image" {
  default = "RHEL-7.5"
}

variable "Image_ID" {
  //    default  = "896c8332-e87d-4007-9e08-cd74496bf89c"
  default = "85b068a0-91f5-4533-b4dd-3d9a93359591"
}

variable "instance_name" {
  default = "Terraform_test_count"
}
