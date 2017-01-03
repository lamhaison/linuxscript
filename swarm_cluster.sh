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


 docker run -d --restart=always swarm join --advertise=10.10.11.241:2375 consul://10.10.11.220:8989
 docker run -d --restart=always swarm join --advertise=10.10.11.242:2375 consul://10.10.11.220:8989
 docker run -d --restart=always swarm join --advertise=10.10.11.248:2375 consul://10.10.11.220:8989


 IFACE='eth0' && IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/') && CONSUL_IP='10.10.11.220' && docker run -d  --restart=always --name=registrator -h $IP --volume=/var/run/docker.sock:/tmp/docker.sock   gliderlabs/registrator -ip $IP -resync 60 -retry-attempts -1 -retry-interval 5000 consul://$CONSUL_IP:8989


  docker rm -f registrator && IFACE='eth0' && IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/') && CONSUL_IP='10.10.11.220' && docker run -d  --restart=always --name=registrator -h $IP --volume=/var/run/docker.sock:/tmp/docker.sock   gliderlabs/registrator -ip $IP -retry-attempts -1 -retry-interval 5000 -resync 120 consul://$CONSUL_IP:8989

node /data/jenkins-home/fimplus_devops/call_swarm.js staging hd1-billing fim-1150-platform-autorenew_85b137aaf78e6766099db9e3dccf7b5bdc38d4bd

sudo python /data/jenkins-home/fimplus_devops/call_swarm_scale.py hd1-billing stag 10

sudo python /data/jenkins-home/fimplus_devops/call_swarm_scale.py hd1-billing stag 20

node /data/jenkins-home/fimplus_devops/call_swarm.js staging hd1-billing FB-280-bo-sung-them-data-tra-ve-khi-lay-_be0b63809979dfc33bdc1d49d068bc77d2480dfa

sudo python /data/jenkins-home/fimplus_devops/call_swarm_scale.py hd1-billing stag 5

sudo python /data/jenkins-home/fimplus_devops/call_swarm_scale.py hd1-billing stag 6

sudo python /data/jenkins-home/fimplus_devops/call_swarm_scale.py hd1-billing stag 2




docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise <manager0_ip>:4000 consul://<consul0_ip>:8500
docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise <manager1_ip>:4000 consul://172.30.0.161:8500




version: '2'

services:
  node_1:
    image: lamhaison/nginxlb:auto_change_config
    network_mode: "host"
    environment:
      - constraint:node==docker-node-1
      - CONSUL_URL=10.10.11.220:8989
      - CD_HOST=http://10.10.5.143:8080
      - SWARM_ENV=stag
    logging:
      driver: syslog
      options:
        syslog-address: udp://10.10.5.143:514
        tag: nginxlb-node-1_stag

  node_2:
    image: lamhaison/nginxlb:auto_change_config
    network_mode: "host"
    environment:
      - constraint:node==docker-node-2
      - CONSUL_URL=10.10.11.220:8989
      - CD_HOST=http://10.10.5.143:8080
      - SWARM_ENV=stag
    logging:
      driver: syslog
      options:
        syslog-address: udp://10.10.5.143:514
        tag: nginxlb-node-2_stag
  node_3:
    image: lamhaison/nginxlb:auto_change_config
    network_mode: "host"
    environment:
      - constraint:node==stag-sw-node3
      - CONSUL_URL=10.10.11.220:8989
      - CD_HOST=http://10.10.5.143:8080
      - SWARM_ENV=stag
    logging:
      driver: syslog
      options:
        syslog-address: udp://10.10.5.143:514
        tag: nginxlb-node-2_stag


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


consul agent -ui -client=0.0.0.0 -data-dir=/tmp/consul -config-dir=/etc/consul.d -server -advertise 172.20.20.10 -bootstrap-expect 3
consul agent -ui -client=0.0.0.0 -data-dir=/tmp/consul -config-dir=/etc/consul.d -server -advertise 172.20.20.11 -join 172.20.20.10
consul agent -ui -client=0.0.0.0 -data-dir=/tmp/consul -config-dir=/etc/consul.d -server -advertise 172.20.20.12 -join 172.20.20.10



consul agent -ui -client=0.0.0.0 -server -bootstrap -data-dir /tmp/consul -advertise 172.20.20.10

consul agent -ui -client=0.0.0.0 -data-dir=/tmp/consul -server -advertise 172.20.20.11
consul agent -ui -client=0.0.0.0 -data-dir=/tmp/consul -server -advertise 172.20.20.12

# consul agent -ui -client=0.0.0.0

consul agent -server -advertise 172.20.20.10 -data-dir /tmp/consul

consul join 172.20.20.11 172.20.20.12


consul agent -config-dir /root/services -data-dir /tmp/consul -client 172.20.20.13 -advertise 172.20.20.13 -ui -join 172.20.20.10


consul agent -data-dir /tmp/consul -client 172.20.20.13 -advertise 172.20.20.13 -ui -join 172.20.20.10

# Query data
consul members -rpc-addr=172.20.20.13:8400

# Show information of cluster
consuk info



docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' -v /docker/consul:/consul --name consul consul agent -server -bind=0.0.0.0 -ui -client=0.0.0.0
-retry-join=10.10.5.149 -advertise 10.10.5.148 -bootstrap-expect=3


docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-v /docker/consul/config:/consul/config \
-v /docker/consul/data:/consul/data \
--name consul \
consul agent -server -bind=0.0.0.0 \
-ui -client=0.0.0.0 \
-retry-join=10.10.5.149 -advertise 10.10.5.148 -bootstrap-expect=3



docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-v /docker/consul/config:/consul/config \
-v /docker/consul/data:/consul/data \
--name consul \
consul agent -server -bind=0.0.0.0 -ui -client=0.0.0.0 \
-retry-join=10.10.5.148 -join=10.10.5.148 \
-advertise 10.10.5.149 -bootstrap-expect=3


docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-v /docker/consul/config:/consul/config \
-v /docker/consul/data:/consul/data \
--name consul \
consul agent -server -bind=0.0.0.0 -ui -client=0.0.0.0 \
-retry-join=10.10.5.149 -join=10.10.5.149 \
-advertise 10.10.5.150 -bootstrap-expect=3








docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
consul agent -server -bind=0.0.0.0 -ui -client=0.0.0.0 -retry-join=172.20.20.12 \
-advertise 172.20.20.10 -bootstrap-expect=3


docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
consul agent -server -bind=0.0.0.0 -ui -client=0.0.0.0 \
-retry-join=172.20.20.10 -join=172.20.20.10 \
-advertise 172.20.20.11 -bootstrap-expect=3


docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
consul agent -server -bind=0.0.0.0 -ui -client=0.0.0.0 \
-retry-join=172.20.20.10 -join=172.20.20.10 \
-advertise 172.20.20.12 -bootstrap-expect=3


docker run -d --net=host \
-v /docker/config:/consul/config \
-e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' \
consul agent -ui -bind=0.0.0.0 -client=0.0.0.0 \
-retry-join=172.20.20.10 -join=172.20.20.10 \
-advertise 172.20.20.13



docker rm -f registrator \
&& IP=172.20.20.1 \
&& CONSUL_IP=172.20.20.12 \
&& docker run -d  --restart=always --name=registrator \
-h $IP --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator \
-ip $IP -retry-attempts -1 -retry-interval 5000 -resync 120 consul://$CONSUL_IP:8500


docker rm -f registrator \
&& IP=172.20.20.13 \
&& CONSUL_IP=172.20.20.13 \
&& docker run -d  --restart=always --name=registrator \
-h $IP --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator \
-ip $IP -retry-attempts -1 -retry-interval 5000 -resync 120 consul://$CONSUL_IP:8500


docker run --name mynginx1 -p 8090:80 -d \
-e SERVICE_CHECK_TTL=30s \
-e SERVICE_80_CHECK_HTTP=/ \
-e SERVICE_80_CHECK_INTERVAL=15s \
-e SERVICE_80_CHECK_TIMEOUT=1s \
nginx


docker run --name mynginx2 -p 8092:80 -d \
-e SERVICE_CHECK_TTL=30s \
-e SERVICE_80_CHECK_HTTP=/ \
-e SERVICE_80_CHECK_INTERVAL=15s \
-e SERVICE_80_CHECK_TIMEOUT=1s \
-e SERVICE_NAME=service_test_1 \
-e SERVICE_CHECK_TTL=30s \
nginx


docker run --name mynginx3 -p 80 -d \
-e SERVICE_CHECK_TTL=30s \
nginx



docker run -d --name redis.0 -p 10000:6379 \
-e SERVICE_NAME=service_test \
-e "SERVICE_TAGS=master,backups" \
redis


docker run -d --name redis.1 -p 10001:6379 \
-e SERVICE_NAME=service_test \
-e "SERVICE_TAGS=master,backups" \
redis



curl -s http://172.20.20.11:8500/v1/catalog/service/service_test_1-80
curl -s http://172.20.20.11:8500/v1/health/checks/service_test_1-80




- name: create consul
  command: docker run --log-driver=syslog --log-opt syslog-address=udp://{{ rsyslog_addr }} --log-opt tag=" {{ hostname }}" -d -h {{ hostname }} --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' -v {{ consul_data }}:/consul --name consul consul agent -server -bind=0.0.0.0 -ui -client=0.0.0.0 -retry-join={{ retry_join }}  -advertise {{ consul_ip }} -bootstrap-expect={{ number_cluster }}
  #docker_container:
  #  name: consul
  #  image: consul
  #  network_mode: host
  #  command: consul agent -server -bind=0.0.0.0 -ui -client=0.0.0.0 -retry-join={{ retry_join }} -advertise {{ consul_ip }} -bootstrap-expect {{ number_cluster }}
  #  state: started
  #  hostname: "{{ hostname }}"
  #  restart_policy: always
  #  volumes:
  #    - "{{ consul_data }}:/consul"
  #  log_options:
  #    syslog-address: "udp://{{ rsyslog_addr }}"
  #    tag: "{{ hostname }}"
  #  log_driver: syslog
  #  env:
  #    - 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' 
  when: init_consul

- name: create consul
  docker_container:
    name: consul
    # image: consul:test
    image: consul
    network_mode: host
    command: agent -server -bind=0.0.0.0 -ui -client=0.0.0.0 -retry-join={{ retry_join }} -advertise {{ consul_ip }} -bootstrap-expect={{ number_cluster }}
    state: started
    hostname: "{{ hostname }}"
    restart_policy: always
    volumes:
      - "{{ consul_data }}:/consul"
    log_options:
      syslog-address: "udp://{{ rsyslog_addr }}"
      tag: "{{ hostname }}"
    log_driver: syslog
    env:
      CONSUL_LOCAL_CONFIG: "{\"skip_leave_on_interrupt\": true}"
  when: not init_consul




docker rm -f registrator \
&& IP=10.10.4.76 \
&& CONSUL_IP=10.10.5.149:8989 \
&& docker run -d  --restart=always --name=registrator \
-h $IP --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator \
-ip $IP -retry-attempts -1 -retry-interval 5000 -resync 120 consul://$CONSUL_IP


docker -H :4000 run --name mynginx2 -p 8092:80 -d \
-e SERVICE_CHECK_TTL=30s \
-e SERVICE_80_CHECK_HTTP=/ \
-e SERVICE_80_CHECK_INTERVAL=15s \
-e SERVICE_80_CHECK_TIMEOUT=1s \
-e SERVICE_NAME=service_test_1 \
-e SERVICE_CHECK_TTL=30s \
nginx