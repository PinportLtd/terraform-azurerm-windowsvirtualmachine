variable "location" {
  description = "The Azure location of the virtual machine."
  default     = "uksouth"
}

variable "resourcegroupname" {
  description = "The Resource Group Name."
  default     = "AREsourceGroup"
}

variable "taglist" {
  type        = map(string)
  description = "This is the tags for the Virtual Machine."
  default = {
    "Created By" = "A Company"
  }
}
