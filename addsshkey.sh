user=sonlh13
sshkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7iRKrfUrbFHtzrD29h002colGq/EESFsPwCXaNKGxdYTdpJPo134i8uLSJNeXzI+0+8uGaJ9dxJYNMRyY7GXHdgWzSKC3ebwObe64Xpv5s5jd0iBRL4uvHeZ0mTq2fUTlak2R80+3sOX5kG084gmx/Nu5pyGg8mubKin5PqXaJQ+6B3aX7vHDgEtUE0fu1zJYCZ4V2FB8cIx5qbO+XcQvvtOttkYFEMLAcJPQJgkenMFCZvJMQ8qOZhGGX5pYt0Cej1vkPOeuGD4gRriK0AGv3ZCZjcfH6Iy7ffy9TJIiCZZB8//cxcJ7ZFtvZDrp+wSd5648+nt+2qjgkPWmujDB dev-fpt"

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
