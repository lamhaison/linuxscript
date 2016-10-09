### Install ntp and start ntp - name simple-playbook.yml
```
---
- hosts: all
tasks:
- name: Ensure NTP (for time synchronization) is installed.
  yum: name=ntp state=installed
- name: Ensure NTP is running.
  service: name=ntpd state=started enabled=yes
```
- check connetion ansile to all server 
```
# multi - name of group in inventory file of ansible
# hostname - check hostname of server
# speed up the process of running commands on 2 of servers at the same time.
ansible multi -a "hostname" -f 2

```
- change directory of inventory file
```
export ANSIBLE_-HOSTS=/etc/ansible/hosts
```
- run commandline on all server
```
# -s: using sudo to perform command run yum install ntpl
# -m: using module yum
ansible multi -s -m yum -a "name=ntp state=installed"
# install ansible and enalbe ntp when start-up vm
ansible multi -s -m service -a "name=ntpd state=started enabled=yes"

# start, sync, enable ntp start on boot 
ansible multi -s -a "service ntpd stop"
ansible multi -s -a "ntpdate -q 0.rhel.pool.ntp.org"
ansible multi -s -a "service ntpd start"
```

- install database and python package
```
ansible app -s -m yum -a "name=MySQL-python state=present"
ansible app -s -m yum -a "name=python-setuptools state=present"
ansible app -s -m easy_install -a "name=django"
```
- setup databse, create user
```
ansible db -s -m yum -a "name=MySQL-python state=present"
ansible db -s -m mysql_user -a "name=django host=% password=12345 \
priv=*.*:ALL state=present"
```

# Example inventory file
```
# Lines beginning with a # are comments, and are only included for
# illustration. These comments are overkill for most inventory files.

 # Application servers
 [app]
 192.168.60.47
 192.168.60.5

 # Database server
 [db]
 192.168.60.6

 # Group 'multi' with all servers
 [multi:children]
 app
 db

 # Variables that will be applied to all servers
 [multi:vars]
 ansible_ssh_user=vagrant
 ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key
```

# Make changes using Ansible modules
```
# install ntp
ansible multi -s -m yum -a "name=ntp state=installed"
# make sure the ntp daemon is started and set to run on boot
ansible multi -s -m service -a "name=ntpd state=started enabled=yes"
```
# Configure groups of servers, or individual servers
```
# install on server with ip is 192.168.60.4
ansible app -s -a "service ntpd restart" --limit "192.168.60.4"

# Limit hosts with a simple pattern (asterisk is a wildcard).
ansible app -s -a "service ntpd restart" --limit "*.4"

# Limit hosts with a regular expression (prefix with a tilde).
ansible app -s -a "service ntpd restart" --limit ~".*\.4"
```

# install django, Mysql-python
```
ansible app -s -m yum -a "name=MySQL-python state=present"
ansible app -s -m yum -a "name=python-setuptools state=present"
ansible app -s -m easy_install -a "name=django"
```

# Configure the Database servers and open port on firewall
```
ansible db -s -m yum -a "name=mariadb-server state=present"
ansible db -s -m service -a "name=mariadb state=started enabled=yes"
ansible db -s -a "iptables -F"
ansible db -s -a "iptables -A INPUT -s 192.168.60.0/24 -p tcp \
-m tcp --dport 3306 -j ACCEPT"
```

# Create user for mysql database
```
ansible db -s -m mysql_user -a "name=django host=% password=12345 \
priv=*.*:ALL state=present"
```

# Manage users and groups
# http://docs.ansible.com/user_module.html
```
# create group
ansible app -s -m group -a "name=admin state=present"

# create user and home directory
ansible app -s -m user -a "name=johndoe group=admin createhome=yes"

# delete account
ansible app -s -m user -a "name=johndoe state=absent remove=yes"
```

# Manage files and directories
```
# Copy a file to the servers
ansible multi -m copy -a "src=/etc/hosts dest=/tmp/hosts"
# Retrieve a file from the server
ansible multi -s -m fetch -a "src=/etc/hosts dest=/tmp"
```

# Create directories and files
```
# create directory
ansible multi -m file -a "dest=/tmp/test mode=644 state=directory"
# Here’s how to create a symlink
ansible multi -m file -a "src=/src/symlink dest=/dest/symlink \
owner=root group=root state=link"

```

# Delete directories and files
```
ansible multi -m file -a "dest=/tmp/test state=absent"
```

# Manage cron jobs
```
# craete job
ansible multi -s -m cron -a "name='daily-cron-all-servers' \
hour=4 job='/path/to/daily-script.sh'"

# delete job
ansible multi -s -m cron -a "name='daily-cron-all-servers' state=absent"
```

# Deploy a version-controlled application
```
ansible app -s -m git -a "repo=git://example.com/path/to/repo.git \
dest=/opt/myapp update=yes version=1.2.4"
ansible app -s -a "/opt/myapp/update.sh"

```


# Ansible playbook
* basic commandline
```
# limit hot run ansible playbook
# Limit group of servers
ansible-playbook playbook.yml --limit webservers
# Limit host
ansible-playbook playbook.yml --limit xyz.example.com

# See list of hosts run ansible playbook
 ansible-playbook playbook.yml --list-hosts
```

* set user and sudo with ansible-playbook
```
# play with user ubuntu
ansible-playbook playbook.yml --remote-user=ubuntu

# run playbook with sudo, performing the task with sudo user ubuntu, Ansible will prompt you for the sudo password
ansible-playbook playbook.yml --sudo --sudo-user=janedoe --ask-sudo-pass


# Other options for ansible-playbook

* --inventory=PATH (-i PATH): Define a custom inventory file (default is the default Ansible
inventory file, usually located at /etc/ansible/hosts).
• --verbose (-v): Verbose mode (show all output, including output from successful options).
You can pass in -vvvv to give every minute detail.
* --extra-vars=VARS (-e VARS): Define variables to be used in the playbook, in "key=value,key=value"
format.
• --forks=NUM (-f NUM): Number for forks (integer). Set this to a number higher than 5 to
increase the number of servers on which Ansible will run tasks concurrently.
* --connection=TYPE (-c TYPE): The type of connection which will be used (this defaults to
ssh; you might sometimes want to use local to run a playbook on your local machine, or on
a remote server via cron).
* --check: Run the playbook in Check Mode (‘Dry Run’); all tasks defined in the playbook will
be checked against all hosts, but none will actually be run.


* run ansible with variable
```
ansible-playbook playbook.yml \
--extra-vars="node_apps_location=/usr/local/opt/node"
```
