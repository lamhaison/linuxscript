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

