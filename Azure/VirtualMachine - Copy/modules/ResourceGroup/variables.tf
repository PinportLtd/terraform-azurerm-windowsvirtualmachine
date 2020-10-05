variable "resourcegroupname" {
        description = "The Name of the Resource Group"
}

variable "location" {
        description = "The Location of the Resource Group"
        default     = "uksouth"
}

variable "taglist" {
  type        = map(string)
  description = "This is the tags for the Virtual Machine."
  default = {

  }
}