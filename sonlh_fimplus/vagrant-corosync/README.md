
```
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
```

# Script
```

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

```