# Set up lab for consul
```
DEMO_BOX_NAME=ubuntu/trusty64 vagrant up

consul agent -server -bootstrap-expect=3 \
    -data-dir=/tmp/consul -node=agent-one -bind=172.20.20.10 \
    -config-dir=/etc/consul.d

consul agent -data-dir=/tmp/consul -node=agent-two \
    -bind=172.20.20.11 -config-dir=/etc/consul.d

consul agent -data-dir=/tmp/consul -node=agent-two \
    -bind=172.20.20.12 -config-dir=/etc/consul.d


consul join 172.20.20.11
```


# Add health check for web service
```
echo '{"check": {"name": "ping",
  "script": "ping -c1 google.com >/dev/null", "interval": "30s"}}' \
  >/etc/consul.d/ping.json

echo '{"service": {"name": "web", "tags": ["rails"], "port": 80,
  "check": {"script": "curl localhost >/dev/null 2>&1", "interval": "10s"}}}' \
  >/etc/consul.d/web.json
```


# Summary
# How many kind of healcheck is in consul?
```
* Health check by calling service is service's health check
* Anythin else Health check is node's health check
```

# How many kind of check is in consul?
```
Script + Interval: check health by calling external tool very interval
HTTP + Interval: check health  by creating get request to service every interal
TCP + Interval: check health by making an TCP connection with netcat tool, ...
Time to Live: Client send put request to server and service consider service's status by check time of the latest message.(Keep alive message)
* /v1/agent/check/pass/<checkId>
* /v1/agent/check/fail/<checkId>

Docker + Interval: check health by calling external application which is packaged within a docker container
```

** Example health check
*** HTTP HEALTH CHECK
```
{
  "check": {
    "id": "api",
    "name": "HTTP API on port 5000",
    "http": "http://localhost:5000/health",
    "interval": "10s",
    "timeout": "1s"
  }
}
'''

*** TTL HEALTH CHECK
```
{
  "check": {
    "id": "web-app",
    "name": "Web App Status",
    "notes": "Web app does a curl internally every 10 seconds",
    "ttl": "30s"
  }
}
```


***  DOCKER CHECK
```
{
"check": {
    "id": "mem-util",
    "name": "Memory utilization",
    "docker_container_id": "f972c95ebf0e",
    "shell": "/bin/bash",
    "script": "/usr/local/bin/check_mem.py",
    "interval": "10s"
  }
}
```