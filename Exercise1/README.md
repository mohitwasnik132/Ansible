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

![Ping Success](https://github.com/mohitwasnik132/Ansible/blob/main/Exercise1/Ping%20Sucess%20nodes.png "a title")
  
   the warning in the pink text can easily be fixed by updating python to python3. But current goal was to check connectivity between the Control and node.
   (or follow [this](https://docs.ansible.com/ansible/latest/reference_appendices/interpreter_discovery.html) document.)
