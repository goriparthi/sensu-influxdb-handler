# sensu-influxdb-handler (InfluxDB V0.9 handler)

This plugin currently works with Sensu V0.20 (Current Latest) and InfluxDB V0.9.2(Current Latest).

This is a handler written in bash to push metrics that sensu collects into influxdb V0.9 DB. I was unable to use the current handlers or get them to work. So I decided to write my own out of frustration.
Make sure you update settings in side this script according to your environment needs. Create the database in influxdb before you get this handler in place.
Performance wise this should not be a bottleneck. I am posting bulk statements into influxDB if you closely watch. SED/AWK utilities are  very optimal. No JSON framework is used.

PRs are always welcome.
