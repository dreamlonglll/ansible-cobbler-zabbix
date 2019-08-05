#!/bin/bash

set -e
IPADDR=$1
echo $IPADDR
if [ ! -n "$1"  ]
then 
  exit 1 
fi
#replace . to space
arr=(${IPADDR//./ })
#get the  top 3 bit for ip address
IPADDR3=${arr[0]}.${arr[1]}.${arr[2]}
sed -i "s/^ServerName .*$/ServerName ${IPADDR}:81/g" /etc/httpd/conf/httpd.conf
sed -i "s/^ServerName .*$/ServerName ${IPADDR}:443/g" /etc/httpd/conf.d/ssl.conf
sed -i "s/^subnet .*.0/subnet ${IPADDR3}.0/g" /etc/cobbler/dhcp.template
sed -i "s/^option routers .*$/option routers ${IPADDR};/g" /etc/cobbler/dhcp.template
sed -i "s/^option domain-name-servers .*$/option domain-name-servers $IPADDR;/g" /etc/cobbler/dhcp.template
sed -i "s/^range dynamic-bootp .*$/range dynamic-bootp ${IPADDR3}.120 ${IPADDR3}.254;/g" /etc/cobbler/dhcp.template
sed -i "s/^next_server: .*$/next_server: $IPADDR/g" /etc/cobbler/settings
sed -i "s/^server: .*$/server: $IPADDR/g" /etc/cobbler/settings

systemctl restart httpd
systemctl restart cobblerd