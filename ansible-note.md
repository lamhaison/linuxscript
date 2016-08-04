# Install ntp and start ntp - name simple-playbook.yml
```
---
- hosts: all
tasks:
- name: Ensure NTP (for time synchronization) is installed.
  yum: name=ntp state=installed
- name: Ensure NTP is running.
  service: name=ntpd state=started enabled=yes
```
# check connetion ansile to all server 
```
# multi - name of group in inventory file of ansible
# hostname - check hostname of server
ansible multi -a "hostname"

```
