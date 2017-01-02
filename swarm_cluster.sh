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


# Please read the openais.conf.5 manual page
totem {
	version: 2

	# How long before declaring a token lost (ms)
	token: 3000

	# How many token retransmits before forming a new configuration
	token_retransmits_before_loss_const: 10

	# How long to wait for join messages in the membership protocol (ms)
	join: 60

	# How long to wait for consensus to be achieved before starting a new round of membership configuration (ms)
	consensus: 3600

	# Turn off the virtual synchrony filter
	vsftype: none

	# Number of messages that may be sent by one processor on receipt of the token
	max_messages: 20

	# Limit generated nodeids to 31-bits (positive signed integers)
	clear_node_high_bit: yes

	# Disable encryption
 	secauth: off

	# How many threads to use for encryption/decryption
 	threads: 0

	# Optionally assign a fixed node id (integer)
	# nodeid: 1234

	# This specifies the mode of redundant ring, which may be none, active, or passive.
 	rrp_mode: none

 	interface {
		# The following values need to be set based on your environment 
		ringnumber: 0
		bindnetaddr: 10.10.11.0 
		broadcast: yes
		mcastport: 5406
	}
	transport: udpu
}

nodelist {
    node {
        ring0_addr: 10.10.11.228
        name: primary
        nodeid: 1
    }

    node {
        ring0_addr: 10.10.11.229
        name: secondary
        nodeid: 2
    }
}




amf {
	mode: disabled
}

quorum {
	# Quorum for the Pacemaker Cluster Resource Manager
	provider: corosync_votequorum
	expected_votes: 1
}

aisexec {
        user:   root
        group:  root
}

logging {
    fileline: off
    to_stderr: yes
    to_logfile: yes
    to_syslog: yes
	syslog_facility: daemon
    debug: off
    timestamp: on
    logger_subsys {
            subsys: AMF
            debug: off
            tags: enter|leave|trace1|trace2|trace3|trace4|trace6
    }

    logfile: /var/log/corosync/corosync.log
}




# vim /etc/corosync/corosync.conf

totem {
        version: 2

        # How long before declaring a token lost (ms)
        token: 3000

        # How many token retransmits before forming a new configuration
        token_retransmits_before_loss_const: 10

        # How long to wait for join messages in the membership protocol (ms)
        join: 60

        # How long to wait for consensus to be achieved before starting a new round of membership configuration (ms)
        consensus: 3600

        # Turn off the virtual synchrony filter
        vsftype: none

        # Number of messages that may be sent by one processor on receipt of the token
        max_messages: 20

        # Limit generated nodeids to 31-bits (positive signed integers)
        clear_node_high_bit: yes

        # Disable encryption
        secauth: off

        # How many threads to use for encryption/decryption
        threads: 0

        # Optionally assign a fixed node id (integer)
        # nodeid: 1234

        # This specifies the mode of redundant ring, which may be none, active, or passive.
        rrp_mode: none
		interface {
                # The following values need to be set based on your environment 
                ringnumber: 0
                bindnetaddr: 172.20.20.0
                mcastaddr: 226.94.1.1
                mcastport: 5405
        }
}

amf {
        mode: disabled
}

quorum {
        # Quorum for the Pacemaker Cluster Resource Manager
        provider: corosync_votequorum
        expected_votes: 1
}

aisexec {
        user:   root
        group:  root
}

nodelist {
  node {
    ring0_addr: 172.20.20.10
    name: n1
    nodeid: 1
  }
  node {
    ring0_addr: 172.20.20.11
    name: n2
	nodeid: 2
  }
}



crm configure delete



 #!/bin/bash
BIND_NETWORK="10.123.10.0"
SHARED_VIP="10.123.10.26"
apt-get update
apt-get install -y pacemaker ntp
# Configure Corosync
echo "START=yes" > /etc/default/corosync
sed -i "s/bindnetaddr: 127.0.0.1/bindnetaddr: $BIND_NETWORK/g" /etc/corosync/corosync.conf
# Start clustering software
service corosync start
service pacemaker start
update-rc.d pacemaker defaults
crm configure <<EOF
primitive virtual-ip ocf:heartbeat:IPaddr \
params ip="$SHARED_VIP"
property stonith-enabled=false
commit
EOF




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


docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
consul agent -server -bind=0.0.0.0 \
-ui -client=0.0.0.0 \
-retry-join=172.20.20.12 -bootstrap-expect=3


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
-e SERVICE_CHECK_TTL=30s \
-e SERVICE_80_CHECK_HTTP=/health_check \
-e SERVICE_80_CHECK_INTERVAL=15s \
-e SERVICE_80_CHECK_TIMEOUT=1s \
-h $IP --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator \
-ip $IP -retry-attempts -1 -retry-interval 5000 -resync 120 consul://$CONSUL_IP:8500


docker run --name mynginx1 -P -d \
-e SERVICE_CHECK_TTL=30s \
-e SERVICE_80_CHECK_HTTP=/health_check \
-e SERVICE_80_CHECK_INTERVAL=15s \
-e SERVICE_80_CHECK_TIMEOUT=1s \
nginx