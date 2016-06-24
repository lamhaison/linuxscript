# Define variable for configuration
LOG_DIR=/data/haproxy
LOG_NAME=haproxy.log
LOG_FILTER=haproxy
RSYS_LOG_CONFIG=/etc/rsyslog.d/11-haproxy.conf

if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
fi

# Change folder log permission
chown syslog.adm $LOG_DIR
echo ":programname, contains, "$LOG_FILTER" $LOG_DIR/$LOG_NAME" > $RSYS_LOG_CONFIG
service rsyslog restart

# Add logorate /etc/logrotate.d/haproxy
/data/haproxy/haproxy.log {
    su syslog syslog
    create 640 syslog syslog
    missingok
    dateformat _%Y-%m-%d
    dateext
    notifempty
    rotate 30
    daily
    compress
    copytruncate
}
EOF


