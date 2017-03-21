vagrant-chaperone
===============

A guide to setup local development environment using vagrant. Your local development
environment can also be used for deployments. This setup will work well for any role that is
simply consuming an api. The roles/tasks involving OVA deployments may have latency issues and
currently this role does not setup mounting local ova directory to the vagrant box.

This role is using vagrant to instantiate an instance of the Chaperone automation tool kit.
This role is using ansible to do the base configuration of the vagrant instance.

Requirements
------------
This role is currently uses and tested with:

* Ubuntu 16.04.2 LTS
* Vagrant 1.9.1
* Ansible 2.2.1.0

CHAP_GUEST_IP is the IP address for the private network being setup for the Vagrant box
<your_project_path> is the full path where you pulled down the chaperone repo usually
in ~/projects


Setup
------------
1. Install [vagrant](https://www.vagrantup.com/docs/installation/) and any dependencies.

2. Install [ansible](http://docs.ansible.com/ansible/intro_installation.html) and any dependencies.

3. Edit /etc/hosts file
```bash
CHAP_GUEST_IP  chaperone-ui.corp.local
```

4. Edit /etc/ansible/ansible.cfg
```bash
roles_path = /etc/ansible/roles:<your_project_path>/containers/vagrant/vagrant_roles
```

5. Source vagrant_setup.sh
```bash
$ source vagrant_setup.sh <your_project_path>
```

6. Run the command
```bash
ansible-galaxy install -p ../../vagrant/galaxy_roles -r requirements.yml
```

6. Edit inventory file <project_path>/chapdev/ansible/playbooks/examples/inventory
```bash
[chaperone-ui]
#chaperone-ui.corp.local           <== Comment out this line
localhost ansible_connection=local <== add this line

[base]
#chaperone-ui.corp.local           <== Comment out this line
localhost ansible_connection=local <== add this line

#[base:vars]                       <== Comment out this line
#ansible_user='vmware'             <== Comment out these lines
#ansible_ssh_pass='VMware1!'
#ansible_become_pass='VMware1!'
```
7. Vagrant up
```bash
$ vagrant up
```
8. Sync project directory. This is kinda a hack. Need to set provisioning order.
```bash
$ vagrant reload
```
9. vagrant ssh
10. Run some more commands. The 'examples/inventory' file should be the file you edited earlier.
```bash
~$ su vmware
~$ cd ~/ansible/playbooks/ansible
~$ ansible-playbook -K -k -i inventory ansible.yml
~$ cd ../chaperone-ui/
~$ ansible-playbook -K -k -i examples/inventory base.yml
~$ ansible-playbook -i examples/inventory ui.yml
```
11. Open a supported browser (just not IE) and go to localhost:
