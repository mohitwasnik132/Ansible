resource "aws_instance" "node" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.sg]
  key_name               = local.key
  user_data              = file("authdata.sh")

  root_block_device {
    volume_size = 15
  }

  tags = {
    Name    = "NODE-${count.index + 1}"
    project = "Ansible-node"
  }
}


resource "aws_instance" "node_amazon" {
  count                  = var.countamazon
  ami                    = data.aws_ami.amazon.image_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.sg]
  key_name               = local.key
  user_data              = file("authcentos.sh")

  root_block_device {
    volume_size = 15
  }

  tags = {
    Name    = "NODE-amazon"
    project = "Ansible-node"
  }
}


resource "aws_instance" "node_rhel8" {
  count                  = var.countamazon
  ami                    = data.aws_ami.rhel8.image_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.sg]
  key_name               = local.key
  user_data              = file("authcentos.sh")

  root_block_device {
    volume_size = 15
  }

  tags = {
    Name    = "NODE-rhel8"
    project = "Ansible-node"
  }
}




resource "null_resource" "setup_nodes" {
  triggers = {
    instance_ids = "${join(",", aws_instance.node.*.id)}"
  }

  count = length(aws_instance.node)


  provisioner "remote-exec" {
    inline = [
      "sudo echo 'hostnamectl set-hostnsme NODE-${count.index}'",
      "echo ${element(aws_instance.node.*.private_ip, 0)}\t\tnode[count.index]\n | tee -a /tmp/hosts",


    ]
    connection {
      user        = var.username
      type        = "ssh"
      private_key = local.private_key
      host        = element(aws_instance.node.*.public_ip, count.index)
    }
    on_failure = continue
  }
  depends_on = [aws_instance.node]
}




resource "null_resource" "amazon" {
  triggers = {
    instance_ids = "${join(",", aws_instance.node_amazon.*.id)}"
  }
  provisioner "remote-exec" {
    inline = [

      "sudo echo 'hostnamectl set-hostname amazon'",
      "sudo echo ${element(aws_instance.node_amazon.*.private_ip, 0)}\t\tamazon\n >> /etc/hosts",



    ]
    connection {
      user        = "ec2-user"
      type        = "ssh"
      private_key = local.private_key
      host        = element(aws_instance.node_amazon.*.public_ip, 0)
    }
    on_failure = continue

  }
  depends_on = [aws_instance.node_amazon]
}



resource "null_resource" "redhat" {
  triggers = {
    instance_ids = "${join(",", aws_instance.node_rhel8.*.id)}"
  }
  provisioner "remote-exec" {
    inline = [

      "sudo amazon-linux-extras install -y epel",
      "sudo yum install -y git",
      "sudo echo ${element(aws_instance.node_rhel8.*.private_ip, 0)}\t\tredhat\n >>/tmp/hosts",



    ]
    connection {
      user        = "ec2-user"
      type        = "ssh"
      private_key = local.private_key
      host        = element(aws_instance.node_rhel8.*.public_ip, 0)
    }
    on_failure = continue

  }
  depends_on = [aws_instance.node_amazon]
}
