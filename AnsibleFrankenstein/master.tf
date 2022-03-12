resource "aws_instance" "master" {
  count                  = var.counts
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [local.sg]
  key_name               = local.key
  user_data              = file("authdata.sh")

  root_block_device {
    volume_size = 15
  }

  tags = {
    Name    = "Master"
    project = "Ansible-practice"
  }
  depends_on = [aws_instance.node]
}







resource "null_resource" "setup_master" {

  triggers = {
    instance_ids = "${join(",", aws_instance.master.*.id)}"
  }
  provisioner "remote-exec" {
    inline = [
      "echo hello nodes",
      "sudo echo 'hostnamectl set-hostname master'",
      "sleep 20; ansible-playbook -i nodes_windows main.yml"
    ]
  
    connection {
      user        = var.username
      type        = "ssh"
      private_key = tls_private_key.key.private_key_pem
      host        = element(aws_instance.master.*.public_ip, 0)
      #host        = local.master.public_ip
    }
    on_failure = continue



  }
  provisioner "file" {
    # source      = "hosts"
    source      = "./plays/"
    destination = "/home/ubuntu/"

    connection {
      user        = var.username
      type        = "ssh"
      private_key = local.private_key
      host        = element(aws_instance.master.*.public_ip, 0)
    }
  }
  depends_on = [local_file.hosts]
}



# resource "local_file" "setupsh" {
#   filename= "setup.sh"
#   content = <<-EOF
#       #! /bin/bash
# sudo amazon-linux-extras install -y epel
# sudo useradd -m -p $(openssl passwd -1 devops) -s /bin/bash -G wheel,adm,sudo devops
# "echo -e 'devops\ndevops' | sudo passwd devops"
# "echo 'devops ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/devops"
# "sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config"

# echo -e 'yes' | ssh devops@local.master_pub

# EOF
# }




