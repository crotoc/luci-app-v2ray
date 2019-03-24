#!/bin/sh

wget-ssl --no-check-certificate https://raw.githubusercontent.com/crotoc/myunblockurl/master/myunblock.txt -O /tmp/myunblock.b64 >&2

cat /tmp/myunblock.b64 | base64 -d > /tmp/myunblock.txt

if [ -s "/tmp/myunblock.txt" ];then
	sort -u /etc/v2ray/base-ublist.txt  /tmp/myunblock.txt | uniq > /tmp/unblock-youku
	if ( ! cmp -s /tmp/unblock-youku /etc/gfwlist/unblock-youku );then
		if [ -s "/tmp/unblock-youku" ];then
			mv /tmp/unblock-youku /etc/gfwlist/unblock-youku
			echo "Update unblock-youku-List Done!"
		fi
	else
		echo "Unblock-youku-List No Change!"
	fi
fi

rm -f /tmp/unblock-youku
rm -f /tmp/myunblock.txt

/etc/init.d/v2raypro restart
