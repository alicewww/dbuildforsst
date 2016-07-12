#!/bin/bash -x
{
	if [ "$#" != "3" ]; then
		echo "Param not 3!"
		exit 1
	fi
	SERVER="$1"
	PORT="$2"
	PASSWD="$3"

	echo "
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        user haproxy
        group haproxy
        daemon

defaults
        timeout connect 3s
        timeout queue 15s
        timeout server 3600s
        timeout client 3600s

frontend fe
        bind 0.0.0.0:10000
        mode tcp
        backlog 4096
        maxconn 50000
        default_backend be

backend be
        mode  tcp
        balance roundrobin
        server web1 $SERVER:$PORT
" >/etc/haproxy/haproxy.cfg

	cron
	/etc/init.d/haproxy start
	/etc/init.d/privoxy restart
	/usr/sbin/squid3

	cd /root/gopath/bin/
	echo "
{
    \"server\":\"$SERVER\",
    \"server_port\":$PORT,
    \"local_port\":10001,
    \"password\":\"$PASSWD\",
    \"method\": \"aes-256-cfb-auth\",
    \"timeout\":600
}
" > config.json

	./shadowsocks-local -d
} >>/ss/ss.log 2>&1
