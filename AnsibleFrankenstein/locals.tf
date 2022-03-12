

locals {

  vpc_id      = data.aws_vpc.default.id
  sg          = aws_security_group.ansible.id
  nodes       = aws_instance.node[*].private_ip
  key         = aws_key_pair.key_pair.key_name
  public_key  = tls_private_key.key.public_key_openssh
  private_key = tls_private_key.key.private_key_pem
  master      = aws_instance.master[*]
  node1       = aws_instance.node[0]
  node2       = aws_instance.node[1]
}


locals {
  name = {

    UBUNTU            = [data.aws_ami.ubuntu.name, data.aws_ami.ubuntu.image_id]
    AMAZON            = [data.aws_ami.amazon.name, data.aws_ami.amazon.image_id]
    WINDOWS-SERVER-12 = [data.aws_ami.windows_12.name, data.aws_ami.windows_12.image_id]
    WINDOWS-SERVER-19 = [data.aws_ami.windows_19.name, data.aws_ami.windows_19.image_id]
    RHEL              = [data.aws_ami.rhel8.name, data.aws_ami.rhel8.image_id]
  }

  publicIP = {
    master_pub  = aws_instance.master[0].public_ip
    node0_pub   = aws_instance.node[0].public_ip
    node1_pub   = aws_instance.node[1].public_ip
    amazon_pub  = aws_instance.node_amazon[0].public_ip
    windows_pub = aws_instance.windows_19[0].public_ip
    rhel_pub    = aws_instance.node_rhel8[0].public_ip

  }


  privateIP = {
    master_pri  = aws_instance.master[0].private_ip
    node0_pri   = aws_instance.node[0].private_ip
    node1_pri   = aws_instance.node[1].private_ip
    amazon_pri  = aws_instance.node_amazon[0].private_ip
    windows_pri = aws_instance.windows_19[0].private_ip
    rhel_pub    = aws_instance.node_rhel8[0].private_ip
  }

}




# locals {
#   passwin = [
#     for inst in aws_instance.windows_19 : rsadecrypt(inst.password_data, tls_private_key.key.private_key_pem)
#   ]
# }


# generate inventory file for Ansible
resource "local_file" "hosts" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      master        = aws_instance.master.*.public_ip
      nodes_ubuntu  = aws_instance.node.*.public_ip
      nodes_amazon  = aws_instance.node_amazon.*.public_ip
      nodes_windows = aws_instance.windows_19.*.public_ip
      password      = local.rsa
      rhel_pub      = aws_instance.node_rhel8.*.public_ip
      passwin = [for inst in aws_instance.windows_19 : rsadecrypt(inst.password_data, tls_private_key.key.private_key_pem)]

    }
  )
  filename = "./plays/hosts"
}






resource "local_file" "ansiblecfg" {
  filename = "./plays/ansible.cfg"
  content = <<-EOF
    [defaults]
    inventory = ./hosts
    host_key_checking = False
    #remote_user = devops
    EOF
}


#  resource "local_file" "hosts" {   
# content = 
#  <<- EOT 
#  [master] 
#  %{ for host, ip in local.privateIP ~} 
#  ${host} ansible_host=${ip}
#  %{ endfor ~} 
#  [nodes] 
#  EOT   

#  filename = "hosts"
#   }



