- Install ntp and start ntp - name simple-playbook.yml
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
```

