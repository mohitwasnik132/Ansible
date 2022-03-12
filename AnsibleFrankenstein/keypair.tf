# resource "aws_key_pair" "mykey" {

#   key_name   = "mykey"
#   public_key = file(var.pubkey)
# }


# resource "tls_private_key" "mykey" {
#   algorithm = "RSA"
# }

# module "key_pair" {
#   source = "terraform-aws-modules/key-pair/aws"

#   key_name   = "mykey"
#   public_key = tls_private_key.mykey.public_key_openssh
# }


resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "ansible"
  public_key = tls_private_key.key.public_key_openssh
}


