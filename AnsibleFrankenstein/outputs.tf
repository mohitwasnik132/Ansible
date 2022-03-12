
# output "passwor" {
#   value     = rsadecrypt(aws_instance.windowsEC2.password_data, tls_private_key.key.private_key_pem)
#   sensitive = true
# }

output "private_ip" {
  value = local.privateIP
}


output "public_ip" {
  value = local.publicIP
}


resource "local_file" "mission" {
  filename = "mission_details.json"
  content = jsonencode(
    { "private_ip" = local.privateIP,

      "public_ip" = local.publicIP,


      "instance_id" = local.name,


      "key" = local.key
    }
  )
}




resource "local_file" "inventory" {
  #description = "Provides all necessary outputs in a file"
  filename = "nodes.ip"
  content  = join("\n", aws_instance.node[*].private_ip)
}



# locals {   hosts = {
#  master = aws_instance.instance[0].private_ip    
#  host1 = aws_instance.instance[1].private_ip
#  host2 = aws_instance.instance[2].private_ip     } }  
#  resource "local_file" "hosts" {   
# content = <<-EOT 
#  [master] %{ for host, ip in local.hosts ~} ${host} ansible_host=${ip} controller=True %{ endfor ~} 
#  [cluster:vars] 
#  EOT   
#  filename = "./playbook/roles/ansible_rhel/templates/hosts" }




output "rhel" {
  value = [
    local.name

  ]

}