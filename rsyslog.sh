# Define variable for configuration
LOG_DIR=/data/haproxy
LOG_NAME=haproxy.log
LOG_FILTER=haproxy
RSYS_LOG_CONFIG=/etc/rsyslog.d/11-haproxy.conf

# Change folder log permission
chown syslog.adm $LOG_DIR
echo ":programname, contains, "$LOG_FILTER" $LOG_DIR/$LOG_NAME" > $RSYS_LOG_CONFIG
service rsyslog restart

cat &gt; /etc/logrotate.d/haproxy &lt;&lt; EOF
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


