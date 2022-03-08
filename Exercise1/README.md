# Ansible - Exercise1

- Added the inventory file.
  - added `node1 ansible_host=private_ip ansible_user=devops ansible_ssh_password = devops`
  - Similarly added details of `node2`
- :point_up_2: produced errors with

  ```bash
  ansible -i inventory-one -m ping node1
  ```

  due to ssh_host_key_check, since instances are not authenticated with each other with ssh keys before this.

- Fixed Error
  modified `/etc/ansible/ansible.cfg`.
  -uncommented `Host_key_checking = False`

- `-m ping node1` works now. `{ping : pong}`
