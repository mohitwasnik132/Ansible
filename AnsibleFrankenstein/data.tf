

#=============WIN-SERVER-12=========================#


data "aws_ami" "windows_12" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2012-R2_RTM-English-64Bit-Base-*"]
  }
}


#=============WIN-SERVER-19=========================#

data "aws_ami" "windows_19" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


#=============UBUNTU-LATEST=========================#


data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}


#=============AMAZON-LATEST=========================#

data "aws_ami" "amazon" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}





#=============AMAZON-LATEST=========================#



data "aws_ami" "rhel8" {
  owners      = ["309956199498"]
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}




#=============OUTPUTS=========================#

# output "ami_name" {
#   value = ([data.aws_ami.ubuntu.name,
#     data.aws_ami.centos.name,
#     data.aws_ami.windows_12.name
#   ])
# }



# output "ami_id" {
#   value = ([data.aws_ami.ubuntu.image_id,
#     data.aws_ami.centos.image_id,
#     data.aws_ami.windows_12.image_id
#   ])
# }


data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id

}




