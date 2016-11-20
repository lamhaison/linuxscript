FROM ubuntu:14.04
MAINTAINER Sven Dowideit <SvenDowideit@docker.com>

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
RUN useradd -d /home/ubuntu ubuntu
RUN mkdir -p /home/ubuntu/.ssh
ADD authorized_keys /home/ubuntu/.ssh/authorized_keys
RUN chown ubuntu:ubuntu -R /home/ubuntu/.ssh
RUN chmod 600 /home/ubuntu/.ssh/authorized_keys
RUN echo "ubuntu	ALL=(ALL)	NOPASSWD: ALL" >> /etc/sudoers
CMD ["/usr/sbin/sshd", "-D"]