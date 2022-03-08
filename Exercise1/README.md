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

![Ping Success](/Exercise1/assets/Ping%20Sucess%20nodes.png "a title")

the warning in the pink text can easily be fixed by updating python to python3. But current goal was to check connectivity between the Control and node.
(or follow [this](https://docs.ansible.com/ansible/latest/reference_appendices/interpreter_discovery.html) document.)

## Ansible Groups

- The ansible Groups are variables that contain the information about the hosts
- Groups in a inventory file are convenient way to apply configuration to multiple hosts at once.
- Refer [this](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#assigning-a-variable-to-many-machines-group-variables) document for configuration.

![Server Added](/Exercise1/assets/added%20db%20server.png "server added")

### Push SSH_KEY into the new server for connectivity and authentication support

- login as `devops` user in `control machine` and `cd /home/devops/.ssh/`

  ```bash
  [devops@ansible-engine .ssh]$ sudo ssh-copy-id devops@172.31.35.246   #private_ip_dbserver
  Are you sure you want to continue connecting (yes/no)? yes
  devops@172.31.35.246's password: devops
  Number of key(s) added: 1

  Now try logging into the machine, with:   "ssh 'devops@172.31.35.246'"
  and check to make sure that only the key(s) you wanted were added.
  ```

- This should add `public key` (content of id_rsa.pub) to `authorized keys` of dbserver.
  - test `group` works.
  ```bash
    ansible -i inverntory-one -m ping dbserver
  ```
- If you get SUCCESS! `{Ping:Pong}` then it worked, test for webserver group as well

### Group and Children

- As `groups` are convenient to apply config to multiple but selective hosts, there is a mechanism called `Children groups` which are basically `Group of Groups` in an inventory file
  these children can be defined with `[name_of_choice:children]` followed by name of groups as we defined hosts.
  ```json
  [myapp:children]
  webservers
  dbserver
  ```
- This can help apply same config to group of groups, as in maybe in a situation you need your certain app installed on only application servers and web-servers but do not want it on adatabse servers. So you simply define `Children` accordingly.
- Variables can be applied to such children via `[children_name:vars]`
- There are certain rules to be followed to avoid headache!

  - Any host that is member of a child group is automatically a member of the parent group.

  - A child group’s variables will have higher precedence (override) a parent group’s variables.

  - Groups can have multiple parents and children, but not circular relationships.

  - Hosts can also be in multiple groups, but there will only be one instance of a host, merging the data from the multiple groups

- Refer [this](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#inheriting-variable-values-group-variables-for-groups-of-groups) documentation for more insight.
- Here is test :point_down:

  ![Children Added](/Exercise1/assets/children%20pinged.png "children added")
