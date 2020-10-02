variable "taglist" {
  type        = map(string)
  description = "This is the tags for the Virtual Machine."
  default = {

  }
}

variable "location" {
  description = "The Azure location of the virtual machine"
}

variable "resourcegroupname" {
  description = "The Resource Group Name"
}

variable "admin_password" {
  description = "This is the Administrator's Password. Use If you are not storing the password in a key vault. This should only be used for testing."
}
