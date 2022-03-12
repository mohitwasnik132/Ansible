
variable "ami_name" {
  default = "ubuntu"

  validation {
    condition     = can(regex("amazon|suse|RHEL|ubuntu", var.ami_name))
    error_message = "Invalid ami name, Available OS = [amazon | RHEL| ubuntu suse | windows] (windows is windows server 19) use one of these only."
  }
}


variable "region_name" {
  default = "mumbai"

   validation {
    condition     = can(regex("tokyo|singapore|sydney|frankfurt|ireland|saopaulo|n.virginia|ohio|n.california|oregon|london|canada|mumbai|jakarta|seoul", var.region_name))
    error_message = "Invalid ami name, Available OS = [tokyo|singapore|sydney|frankfurt|ireland|saopaulo|n.virginia|ohio|n.california|oregon|london|canada|mumbai|jakarta|seoul]. use one of these."
  }
}