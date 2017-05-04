HOST_NAME="collect-agnet"
ENVIRONMENT="dev"
MONITOR_SERVER="x.x.x.x"
CONFIG_PATH=/etc/collectd/collectd.conf

apt-get -y install collectd
apt-get -y install sysv-rc-conf
rm -rf /etc/collectd/*
cat > $CONFIG_PATH <<EOL
Hostname    "$HOST_NAME"
Interval     30
Timeout      5

<LoadPlugin memory>
      Interval 300
</LoadPlugin>


<LoadPlugin df>
      Interval 300
</LoadPlugin>

LoadPlugin disk
LoadPlugin cpu
LoadPlugin interface
LoadPlugin load
LoadPlugin write_graphite
LoadPlugin aggregation
LoadPlugin "match_regex"
<Chain "PostCache">
  <Rule> # Send "cpu" values to the aggregation plugin.
    <Match regex>
      Plugin "^cpu$"
      PluginInstance "^[0-9]+$"
    </Match>
    <Target write>
      Plugin "aggregation"
    </Target>
    Target stop
  </Rule>
  Target "write"
</Chain>
<Plugin "aggregation">
  <Aggregation>
    Plugin "cpu"
    Type "cpu"

    GroupBy "Host"
    GroupBy "TypeInstance"

    CalculateAverage true
  </Aggregation>
</Plugin>


<Plugin df>
       MountPoint "/"
       IgnoreSelected false
       ReportByDevice false
       ReportReserved false
       ReportInodes true
       ValuesAbsolute false
       ValuesPercentage true
</Plugin>


<Plugin interface>
        IgnoreSelected false
       	Interface "eth0"
</Plugin>
<Plugin write_graphite>
  <Node "Monitor">
    Host "$MONITOR_SERVER"
    Port "2003"
    Protocol "tcp"
    LogSendErrors true
    Prefix "$ENVIRONMENT."
    StoreRates true
    AlwaysAppendDS false
    EscapeCharacter "_"
  </Node>
</Plugin>

EOL

cat /etc/collectd/collectd.conf
service collectd start
sysv-rc-conf collectd on
