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