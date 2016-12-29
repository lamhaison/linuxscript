# Setup consul cluster
* Consul 01
```
# ip_node_1
IFACE='eth0' && IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/')
docker run -d -h node1 --restart=always --name=consul-node1 -v /docker/consul:/data \
    -p 0.0.0.0:8300:8300 \
    -p 0.0.0.0:8301:8301 \
    -p 0.0.0.0:8301:8301/udp \
    -p 0.0.0.0:8302:8302 \
    -p 0.0.0.0:8302:8302/udp \
    -p 0.0.0.0:8400:8400 \
    -p 0.0.0.0:8500:8500 \
    -p 0.0.0.0:53:53/udp \
    progrium/consul -server -advertise $IP -bootstrap-expect 3

```

* Consul 02
```
# ip node 2
# IFACE='eth0' && IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/')
IP=ip_node_2
docker run -d -h node2 --restart=always -v /docker/consul:/data \
    -p 0.0.0.0:8300:8300 \
    -p 0.0.0.0:8301:8301 \
    -p 0.0.0.0:8301:8301/udp \
    -p 0.0.0.0:8302:8302 \
    -p 0.0.0.0:8302:8302/udp \
    -p 0.0.0.0:8400:8400 \
    -p 0.0.0.0:8500:8500 \
    -p 0.0.0.0:53:53/udp \
    progrium/consul -server -advertise $IP -join $CONSUL_MASTER

```


* Consul 03
```
# IFACE='eth0' && IP=$(ip -4 address show $IFACE | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/')
IP=ip_node_3
docker run -d -h node3 --restart=always -v /docker/consul:/data \
    -p 0.0.0.0:8300:8300 \
    -p 0.0.0.0:8301:8301 \
    -p 0.0.0.0:8301:8301/udp \
    -p 0.0.0.0:8302:8302 \
    -p 0.0.0.0:8302:8302/udp \
    -p 0.0.0.0:8400:8400 \
    -p 0.0.0.0:8500:8500 \
    -p 0.0.0.0:53:53/udp \
    progrium/consul -server -advertise $IP -join $CONSUL_MASTER

```

* Cluster Docker Swarm Cluster
* Swarm Master 1
```
# VIP_HA:8989: VIP and Port of service on Haproxy
docker run -d --restart=always -p 4000:4000 swarm manage -H :4000 consul://VIP_HA:8990
```

* Swarm Master 2:
```
docker run -d --restart=always -p 4000:4000 swarm manage -H :4000 consul://VIP_HA:8990
```

* Swarm Master 3:
```
docker run -d --restart=always -p 4000:4000 swarm manage -H :4000 consul://VIP_HA:8990
```

* Haproxy
```
global
    log 127.0.0.1    local0
    log 127.0.0.1    local1 notice
    log 10.10.5.143    local0
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    tune.ssl.default-dh-param 2048
    daemon

defaults
    log     global
    mode    tcp
    option      tcplog
    option  dontlognull
    option  abortonclose    # abort request if client closes output channel while waiting client IPs
    timeout connect 5000
    timeout client  15000
    timeout server  30000
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http


listen appname
    mode http
    bind *:8989
    stats enable
    stats uri /haproxy?stats
    stats realm Strictly\ Private
    stats auth ubuntu
    balance roundrobin
    option httpclose
    option forwardfor
    server consul0 ip_node_1:8500 check fastinter 1000 fall 1 rise 1 maxconn 512
    server consul1 ip_node_2:8500 check fastinter 1000 fall 1 rise 1 maxconn 512 backup
    server consul2 ip_node_3:8500 check fastinter 1000 fall 1 rise 1 maxconn 512 backup


frontend incoming_stats
    bind    *:80
    mode    http
    stats enable
    stats uri /stats        # Real path redacted
    stats realm Haproxy\ Statistics
    stats auth  admin:admin

listen swarm
    mode http
    bind *:8990
    balance roundrobin
    option httpclose
    option forwardfor
    server sw_master1 ip_node_1:4000 check fastinter 1000 fall 1 rise 1 maxconn 512 backup
    server sw_master2 ip_node_2:4000 check fastinter 1000 fall 1 rise 1 maxconn 512
    server sw_master3 ip_node_3:4000 check fastinter 1000 fall 1 rise 1 maxconn 512 backup

frontend consul-https
    bind *:443 ssl crt /etc/ssl/certs/server.bundle.pem
    reqadd X-Forwarded-Proto:\ http
    rspadd Strict-Transport-Security:\ max-age=31536000
    acl     test_ssl hdr_dom(host) -i consul.mycompany.com
    use_backend     consul_server  if      test_ssl



backend consul_server
    balance roundrobin
    server consul_node1 ip_node_1:8500 check inter 5000 fastinter 1000 fall 1 rise 1 maxconn 4096 weight 6
    server consul_node2 ip_node_2:8500 check inter 5000 fastinter 1000 fall 1 rise 1 maxconn 4096 weight 6 backup
    server consul_node3 ip_node_3:8500 check inter 5000 fastinter 1000 fall 1 rise 1 maxconn 4096 weight 6 backup
```