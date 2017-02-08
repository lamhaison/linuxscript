CONSUL_MASTER=10.10.11.228
IFACE='eth0' && IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/')
docker run -d -h node1 --restart=always -v /docker/consul:/data \
    -p 0.0.0.0:8300:8300 \
    -p 0.0.0.0:8301:8301 \
    -p 0.0.0.0:8301:8301/udp \
    -p 0.0.0.0:8302:8302 \
    -p 0.0.0.0:8302:8302/udp \
    -p 0.0.0.0:8400:8400 \
    -p 0.0.0.0:8500:8500 \
    -p 0.0.0.0:53:53/udp \
    progrium/consul -server -advertise $IP  -join $CONSUL_MASTER


docker run -d --restart=always --log-driver=syslog --log-opt syslog-address=udp://10.10.5.143 --log-opt tag="swarm_stag_1" --name=swarm_master -p 4000:4000 swarm manage -H :4000 --replication --advertise 10.10.11.62:4000 consul://10.10.11.220:8989
docker run -d --restart=always --log-driver=syslog --log-opt syslog-address=udp://10.10.5.143 --log-opt tag="swarm_stag_2" --name=swarm_master -p 4000:4000 swarm manage -H :4000 --replication --advertise 10.10.11.228:4000 consul://10.10.11.220:8989
docker run -d --restart=always --log-driver=syslog --log-opt syslog-address=udp://10.10.5.143 --log-opt tag="swarm_stag_3" --name=swarm_master -p 4000:4000 swarm manage -H :4000 --replication --advertise 10.10.11.229:4000 consul://10.10.11.220:8989



docker rm -f swarm_master && docker run -d --restart=always --log-driver=syslog --log-opt syslog-address=udp://10.10.5.143 --log-opt tag="swarm_stag_1" --name=swarm_master -p 4000:4000 swarm manage -H :4000 --replication --heartbeat=120s --advertise 10.10.11.62:4000 consul://10.10.11.220:8989
docker rm -f swarm_master && docker run -d --restart=always --log-driver=syslog --log-opt syslog-address=udp://10.10.5.143 --log-opt tag="swarm_stag_2" --name=swarm_master -p 4000:4000 swarm manage -H :4000 --replication --heartbeat=120s --advertise 10.10.11.228:4000 consul://10.10.11.220:8989
docker rm -f swarm_master && docker run -d --restart=always --log-driver=syslog --log-opt syslog-address=udp://10.10.5.143 --log-opt tag="swarm_stag_3" --name=swarm_master -p 4000:4000 swarm manage -H :4000 --replication --heartbeat=120s --advertise 10.10.11.229:4000 consul://10.10.11.220:8989



docker rm -f swarm_master && docker run -d --restart=always --log-driver=syslog --log-opt syslog-address=udp://10.10.5.143 --log-opt tag="swarm_stag_1" --name=swarm_master -p 4000:4000 swarm manage -H :4000 consul://10.10.11.220:8989
docker rm -f swarm_master && docker run -d --restart=always --log-driver=syslog --log-opt syslog-address=udp://10.10.5.143 --log-opt tag="swarm_stag_2" --name=swarm_master -p 4000:4000 swarm manage -H :4000 consul://10.10.11.220:8989
docker rm -f swarm_master && docker run -d --restart=always --log-driver=syslog --log-opt syslog-address=udp://10.10.5.143 --log-opt tag="swarm_stag_3" --name=swarm_master -p 4000:4000 swarm manage -H :4000 consul://10.10.11.220:8989



docker run -d --restart=always -p 4000:4000 swarm manage -H :4000 --replication --advertise 10.10.11.62:4000 consul://10.10.5.143:8500

docker run -d --restart=always -p 4000:4000 swarm manage -H :4000 --replication --advertise 10.10.11.228:4000 consul://10.10.5.143:8500


docker run -d --restart=always -p 4000:4000 swarm manage -H :4000 --replication --advertise 10.10.11.229:4000 consul://10.10.5.143:8500



docker run -d --restart=always -p 4000:4000 swarm manage -H :4000 consul://10.10.11.220:8990

docker run -d --restart=always -p 4000:4000 swarm manage -H :4000 consul://10.10.11.220:8990


docker run -d --restart=always -p 4000:4000 swarm manage -H :4000 consul://10.10.11.220:8990



 IFACE='eth0' && IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/') && CONSUL_IP='10.10.11.220' && docker run -d  --restart=always --name=registrator -h $IP --volume=/var/run/docker.sock:/tmp/docker.sock   gliderlabs/registrator -ip $IP -resync 60 -retry-attempts -1 -retry-interval 5000 consul://$CONSUL_IP:8989


docker rm -f registrator && IFACE='eth0' && IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/') && CONSUL_IP='10.10.11.220' && docker run -d  --restart=always --name=registrator -h $IP --volume=/var/run/docker.sock:/tmp/docker.sock   gliderlabs/registrator -ip $IP -retry-attempts -1 -retry-interval 5000 -resync 120 consul://$CONSUL_IP:8989



docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise <manager0_ip>:4000 consul://<consul0_ip>:8500
docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise <manager1_ip>:4000 consul://172.30.0.161:8500




docker run -d -h node1 -v /mnt:/data \
    -p 0.0.0.0:8300:8300 \
    -p 0.0.0.0:8301:8301 \
    -p 0.0.0.0:8301:8301/udp \
    -p 0.0.0.0:8302:8302 \
    -p 0.0.0.0:8302:8302/udp \
    -p 0.0.0.0:8400:8400 \
    -p 0.0.0.0:8500:8500 \
    progrium/consul -server -advertise 10.0.1.1 -bootstrap-expect 3

docker run -d -h node2 -v /mnt:/data  \
    -p 0.0.0.0:8300:8300 \
    -p 0.0.0.0:8301:8301 \
    -p 0.0.0.0:8301:8301/udp \
    -p 0.0.0.0:8302:8302 \
    -p 0.0.0.0:8302:8302/udp \
    -p 0.0.0.0:8400:8400 \
    -p 0.0.0.0:8500:8500 \
    progrium/consul -server -advertise 10.0.1.2 -join 10.0.1.1




/bin/consul agent -config-dir=/config -server -advertise 10.10.5.148 -bootstrap-expect 3
/bin/consul agent -config-dir=/config -server -advertise 10.10.5.149 -join 10.10.5.148
/bin/consul agent -config-dir=/config -server -advertise 10.10.5.150 -join 10.10.5.148





# Run registrator
docker rm -f registrator \
&& IFACE='eth0' \
&& IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/') \
&& CONSUL_IP='10.1.2.18:8500' \
&& TAG='stag' \
&& docker run -d  --restart=always --name=registrator -h $IP \
--volume=/var/run/docker.sock:/tmp/docker.sock   gliderlabs/registrator \
-tags $TAG -ip $IP \
-retry-attempts -1 -retry-interval 5000 -resync 120 consul://$CONSUL_IP


docker rm -f registrator \
&& IFACE='eth0' \
&& IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/') \
&& CONSUL_IP='10.1.3.4:8500' \
&& TAG='sand' \
&& docker run -d  --restart=always --name=registrator -h $IP \
--volume=/var/run/docker.sock:/tmp/docker.sock   gliderlabs/registrator \
-tags $TAG -ip $IP \
-retry-attempts -1 -retry-interval 5000 -resync 120 consul://$CONSUL_IP






- name: check docker swarm master
  command: "docker ps -f name=swarm-master -q"
  register: p

- name: stop docker swarm master {{ p.stdout }}
  command: "docker stop {{ p.stdout }}"
  when: p.stdout != ""

- name: delete docker swarm master
  command: "docker rm -f {{ p.stdout }}"
  when: p.stdout != ""

# - name: create swarm master
#   docker_container:
#     name: swarm-master
#     image: swarm
#     network_mode: host
#     command: manage -H :4000 consul://{{ consul_url }}
#     state: started
#     hostname: "swarm-{{ hostname }}"
#     restart_policy: always
#     log_options:
#       syslog-address: "udp://{{ rsyslog_addr }}"
#       tag: "swarm_{{ hostname }}"
#     log_driver: syslog
