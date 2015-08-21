####################################################
#Licensed under : The MIT License (MIT)
#
#Copyright (c) 2015 Prashanth Goriparthi
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
####################################################

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
