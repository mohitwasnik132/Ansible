
variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "prikey" {
  default = "mykey"
}

variable "pubkey" {
  default = "mykey.pub"
}

variable "username" {
  default = "ubuntu"
}

variable "user" {
  type    = string
  default = "devops"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}


variable "pass" {
  type    = string
  default = "devops"
}

variable "counts" {
  type    = number
  default = 1
}

variable "countwin" {
  type    = number
  default = 1
}

variable "countsubuntu" {
  type    = number
  default = 1
}
variable "countamazon" {
  type    = number
  default = 1
}
#TO DO : add variable count for every type
variable "winuser" {
  type    = string
  default = "administrator"
}


variable "winpass" {
  type    = string
  default = "password"
}




