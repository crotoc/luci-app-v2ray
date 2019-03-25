#!/bin/sh

wget-ssl --no-check-certificate https://raw.githubusercontent.com/crotoc/unblock-youku-list/master/unblock-youku.txt -O /tmp/ol-unblock-youku.b64 >&2

cat /tmp/ol-unblock-youku.b64 | base64 -d > /tmp/ol-unblock-youku.txt

if [ -s "/tmp/ol-unblock-youku.txt" ];then
	sort -u /etc/v2ray/base-ublist.txt  /tmp/ol-unblock-youku.txt | grep -v "#" | sed -n '/./p' |uniq > /tmp/unblock-youku
	if ( ! cmp -s /tmp/unblock-youku /etc/gfwlist/unblock-youku );then
		if [ -s "/tmp/unblock-youku" ];then
			mv /tmp/unblock-youku /etc/gfwlist/unblock-youku
			echo "Update unblock-youku-List Done!"
		fi
	else
		echo "Unblock-youku-List No Change!"
	fi
fi

rm -f /tmp/ol-unblock-youku.b64
#rm -f /tmp/ol-unblock-youku.txt
#rm -f /tmp/unblock-youku

/etc/init.d/v2raypro restart
