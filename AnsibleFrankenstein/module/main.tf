# To,
# anyone in need..
# This is just a simple code I did while I learned
#This should help you set up environment easier
#will try and update it more..
#provide or add your own aws credentials aws-cli
# with aws configure and then use this file 

#In hindsight I could have made one local block
#But this is better too in a way for code readability..


#|||||||||||||||||||||||-=-REGION DATA-=-|||||||||||||||||||||||||||||||#


provider "aws" { region = lookup(local.regions, var.region_name) }


data "aws_region" "current" {}


locals {
  regions = {
            "tokyo":"ap-northeast-1",
            "singapore":"ap-southeast-1",
            "sydney":"ap-southeast-2",
            "frankfurt":"eu-central-1",
            "ireland":"eu-west-1",
            "saopaulo":"sa-east-1",
            "n.virginia":"us-east-1",
            "ohio":"us-east-2",
            "n.california":"us-west-1",
            "oregon":"us-west-2",
            "london":"eu-west-2",
            "canada":"ca-central-1",
            "mumbai" : "ap-south-1"
            "jakarta": "ap-southeast-3"
            "seoul" : "ap-northeast-2"
}
}

#It was pain to generate and set above list key:pair But it works






#|||||||||||||||||||||||-=-AMI DATA-=-|||||||||||||||||||||||||||||||#


#
#you can add your own images. I just added my most used.
# "imagename-you_want" : {owner : "owner_name", filter : "startingString_and_glob*"}

locals {
  the_os = {
    "amazon" : { owner : "amazon", filter : "amzn2-ami-hvm*" },
    "suse" : { owner : "amazon", filter : "*suse*" },
    "RHEL" : { owner : "amazon", filter : "*RHEL*" },
    "ubuntu" : { owner : "099720109477", filter : "*hvm-ssd/ubuntu-focal-20.04-amd64-server-*" },
    "windows" : { owner :"amazon", filter : "Windows_Server-2019-English-Full-Base-*"},
    
  }
}





data "aws_ami" "os" {
  for_each = local.the_os

  most_recent = true
  owners      = [each.value.owner]
  filter {
    name   = "name"
    values = [each.value.filter]
  }
}




#|||||||||||||||||||||||-=-Basic Test Instance-=-|||||||||||||||||||||||||||||#
 resource "aws_instance" "instance" {
  
  ami                    = data.aws_ami.os[var.ami_name].id
  instance_type          = "t2.micro"
 
 }


