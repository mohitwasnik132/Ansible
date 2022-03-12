[master]
%{ for ip in master ~}
control ansible_host=${ip}
%{ endfor ~}

[nodes_ubuntu]
%{ for index, ip in nodes_ubuntu ~}
${format("ubuntu-%02d", index + 1)} ansible_host=${ip}
%{ endfor ~}

[nodes_windows]
%{ for index, ip in nodes_windows ~}
${format("windows-%02d", index + 1)} ansible_host=${ip}
%{ endfor ~}

[nodes_amazon]
%{ for index, ip in  nodes_amazon ~}
${format("amazon-%02d", index + 1)} ansible_host=${ip}
%{ endfor ~}

[linux:children]
master
nodes_ubuntu
nodes_amazon

[nodes_windows:vars]
ansible_user=Administrator
%{ for pass in passwin ~}
ansible_password=${pass}
%{ endfor ~}
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
ansible_python_interpreter=/usr/bin/python3

[linux:vars]
ansible_user=devops
ansible_password=devops
ansible_connection=ssh
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=/home/devops/.ssh/id_rsa

