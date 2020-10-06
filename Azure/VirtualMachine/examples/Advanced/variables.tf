variable "location" {
  description = "The Azure location of the virtual machine."
  default     = "uksouth"
}

variable "resourcegroupname" {
  description = "The Resource Group Name."
  default     = "DeathRace"
}


variable "servernamesandcount" {
    description = "Description"
    default     = {
        "foo" = 1
        "bar" = 1
    }
  } 

variable "taglist" {
  type        = map(string)
  description = "This is the tags for the Virtual Machine."
  default = {
    "Created By" = "Pinport Ltd"
  }
}
