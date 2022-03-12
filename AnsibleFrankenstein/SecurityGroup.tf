# module "ansible_sg" {
#   source      = "terraform-aws-modules/security-group/aws"
#   version     = "4.7.0"
#   name        = "ansible_ssh"
#   description = "Security group for HTTP/HTTPS/SSH access"

#   vpc_id              = data.aws_vpc.default.id
#   ingress_cidr_blocks = ["0.0.0.0/0"]
#   ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp", "rdp-tcp", "rdp-udp", "winrm-http-tcp", "winrm-https-tcp"]
#   egress_rules        = ["all-all"]
# }


resource "aws_security_group" "ansible" {
  name        = "ansible-lab-sg"
  description = "Created with Terraform for VariousAccess"

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP Access"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPs Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Winrm Access"
    from_port   = 5985
    to_port     = 5990
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "allow_Ports"
    Project = "Practice"
    Purpose = "Demo"
  }
}




resource "aws_security_group" "allow_all" {
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "allow_ALL_Ports"
    Project = "Practice"
    Purpose = "Demo"
  }
}
