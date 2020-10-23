variable "location" {
  description = "The Azure location of the virtual machine."
  default     = "uksouth"
}

variable "resourcegroupname" {
  description = "The Resource Group Name."
  default     = "AResourceGroup"
}

variable "admin_password" {
  description = "This is the Administrator's Password. Use If you are not storing the password in a key vault."
  default     = "AsimplePassword2CRACK"
}

