Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash


sudo apt update




sudo yum install epel-release
sudo yum install ansible python python3 -y
sudo yum install -y ansible

# add user devops
sudo useradd -m -p $(openssl passwd -1 devops) -s /bin/bash -G wheel,adm devops
# add user devops to sudoers list

echo -e "devops\tALL=(ALL:ALL)\tNOPASSWD:ALL" > /etc/sudoers.d/devops

#login as devops and generate ssh

echo "creating ssh keys"

#ssh-keygen -f devopskey -C 'ansible-ssh' -t rsa -b 2048 -q -N ""

sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config

#sudo service sshd restart
sudo systemctl restart sshd.service

echo "All done!"