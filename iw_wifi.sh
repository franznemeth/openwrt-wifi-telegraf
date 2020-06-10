#! /bin/ash
ifaces="$@"
# This could definitely be improved
# hostname=$(cat /etc/config/system | grep -A 8 "config system" | grep hostname | awk '{print $3}' | tr -d "'")

for iface in $ifaces; do
  stations=`iw dev $iface station dump | grep Station | awk '{print $2}'`
  for sta in $stations; do
    metrics=""
    iw dev $iface station get $sta | tail -n+2 | ( while read line; do
        line=$(echo "$line" | sed 's/:[\t ]*/=/g' | awk 'BEGIN{FS=OFS="="} {gsub(/[ \/]/, "_", $1) gsub(/ .*/, "", $2)} 1')
        metrics=$(echo $metrics,$line)
    done
    metrics=$(echo ${metrics:1} | sed 's/yes/1/g' | sed 's/no/0/g' | sed 's/Mbps//g' | sed 's/long/1/g' | sed 's/short/0/g')
    client=$(grep -i $sta /var/dhcp.leases | awk '{print "client_ip="$3",client_name="$4""}')
    client=$(echo $client | sed 's/*/none/g')
    client="client_mac=${sta},${client}"
    echo "wifistats,interface=${iface},${client} ${metrics}" )
  done
done