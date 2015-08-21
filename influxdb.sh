#!/bin/bash

#InfluxDB Settings
influxdb_host=localhost
influxdb_port=8086
influxdb_dbname=sensu

#Read data to parse into influxdb
read x 

#get payload into a variable
output=$(echo $x | grep -Po '(?<="output":")[^"]*' | sed -e 's/ \([0-9]*\)n/ \1||/g' | tr "||" "\n" | sed -e 's/\\n//g' | sed -e 's/\(com\)\.\|\(local\)\./\1\2 /g' | awk '{sub("[.]"," ", $2); print}' | awk '{ print $2",server="$1",metric="$3" value="$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$15" "$16" "$17" "$18" "$19" "$20 }' | egrep -v "^," | sed -e 's/_str_/"/g' | while read y ; do 
	echo "$y\n" 
done)

#Bulk post data
echo "Posting to influx"
curl -i -X POST "http://$influxdb_host:$influxdb_port/write?db=$influxdb_dbname&precision=s" --data-binary "`echo -e $output | sed -e "s/^[ \t]*//" | sed -e "/^\s*$/d"`" > /dev/null 2>&1
