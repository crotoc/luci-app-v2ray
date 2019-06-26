#!/bin/bash
echo "create oversea hash:net family inet hashsize 1024 maxelem 65536" > /tmp/oversea.ipset
echo "add ips from /etc/config/oversea.list to oversea"
awk '!/^$/&&!/^#/&&/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/{printf("add oversea %s'" "'\n",$0)}' /etc/config/oversea.list >> /tmp/oversea.ipset
ipset -! flush oversea
ipset -! restore < /tmp/oversea.ipset 2>/dev/null
rm -f /tmp/oversea.ipset

echo "add address from /etc/config/oversea.list to oversea"
awk '!/^$/&&!/^#/&&!/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/{printf("ipset=/%s/'"oversea"'\n",$0)}' /etc/config/oversea.list > /etc/dnsmasq.oversea/custom_forward.conf
