











#===================SERVER-19===================================

resource "aws_instance" "windows_19" {
  count                  = 1
  ami                    = data.aws_ami.windows_19.image_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ansible.id]
  get_password_data      = "true"
  user_data              = file("winrmconnect.ps1")
  tags = {
    Name = "SERVER-19"
  }

}








resource "null_resource" "connect_winrm" {

  triggers = {
    instance_ids = "${join(",", aws_instance.windows_19.*.id)}"
  }
  provisioner "remote-exec" {
    inline = [
      "echo hello world",
      
      ]

    connection {

      host     = element(aws_instance.windows_19.*.public_ip, 0)
      type     = "winrm"
      password = tostring(element(local.rsa, 0))
    }
  }

  depends_on = [
    aws_instance.windows_19
  ]
}

locals {
  rsa = [for inst in aws_instance.windows_19 : rsadecrypt(inst.password_data, tls_private_key.key.private_key_pem)]

}

resource "local_file" "passdata" {
  filename          = "winpass.txt"
  content           = element(local.rsa, 0)
  
}

# output "passwor" {
#   value     = for inst in aws_instance.windows_19 : rsadecrypt(inst.password_data, tls_private_key.key.private_key_pem)
#   sensitive = true
# }