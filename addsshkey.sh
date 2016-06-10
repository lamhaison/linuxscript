user=vuth
sshkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQLc8ROhqoGKdKrhOLnQQMJaGiVhuyQLXH19xC1uWYnwxl1USeWmzTavVhyzR6kgkw0N/HvTurcxGvtTUBYRUhtbL5ZKSDC3v86nfT49lZxQFTUYEvdQc8vpaFvnAXHT/wuwySOuk22I03UDPnnYNCPGNWjxTk3+wyjJ2107JXJhpF8IW4nq21Y1u/MzpFHcL+4fd1JUf5FLsXplvAHe+ED2E3RswGNHQrCthrRkWuAKsIs+uN7vpLti0i1zBTkOfQTopPRtoCHeAmFFrPTxj0PTjJPdlZp/96wJZ88u7iW98c/MhxkrwfC7GX+dlf7DpMyzsAwu4SENHIlLKETaVF root@Lab"

/usr/sbin/useradd $user
/bin/mkdir /home/$user/.ssh
grep -rl "$sshkey" /home/$user/.ssh/authorized_keys
if [ $? != 0 ]
then
echo "$sshkey" >> /home/$user/.ssh/authorized_keys
fi
grep -rl "$user" /etc/sudoers
if [ $? != 0 ]
then
echo "$user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi
chown -R $user.$user /home/$user
