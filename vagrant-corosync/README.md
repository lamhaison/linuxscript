
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


primitive p_api-ip ocf:heartbeat:IPaddr2 \
    params ip="10.10.0.90" cidr_netmask="24" nic="eth0" \
    op monitor interval="10s"

primitive lb-haproxy lsb:haproxy \
    op monitor interval="10s"
primitive p_api-ip ocf:heartbeat:IPaddr2 \
    params ip="10.10.0.90" cidr_netmask="24" nic="eth0" \
    op monitor interval="10s"
primitive p_management-ip ocf:heartbeat:IPaddr2 \
    params ip="103.205.104.157" cidr_netmask="24" nic="eth1" \
    op monitor interval="10s"
colocation lb-haproxy-with-p_api-ip inf: lb-haproxy p_api-ip
colocation p_management-ip-with-p_api-ip inf: p_management-ip p_api-ip
order lb-haproxy-after-p_api-ip inf: p_api-ip lb-haproxy
order p_management-ip-after-p_api-ip inf: p_api-ip p_management-ip
property $id="cib-bootstrap-options" \
    dc-version="1.1.10-42f2063" \
    cluster-infrastructure="corosync" \
    stonith-enabled="false" \
    no-quorum-policy="ignore"





# commandline
```

# Commandline
# check corosync service
sudo corosync-cmapctl | grep members

# Check Pacemaker with crm:
sudo crm status

# Verify pacemaker confuguration
sudo crm configure show

crm resource stop Apache
crm configure delete Apache

# set standby status for Node Name
sudo crm node standby NodeName

# Set online status for node name
sudo crm node online NodeName

# edit a resource
sudo crm configure edit ResourceName
sudo crm resource stop ResourceName
sudo crm configure delete ResourceName
```


sudo crm configure primitive Nginx ocf:heartbeat:nginx \
  params httpd="/usr/sbin/nginx" \
  op start timeout="40s" interval="0" \
  op monitor timeout="30s" interval="10s" on-fail="restart" \
  op stop timeout="60s" interval="0"




