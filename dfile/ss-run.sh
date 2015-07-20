#!/bin/bash -x
{
	if [ "$#" != "3" ]; then
		echo "Param not 3!"
		exit 1
	fi
	SERVER="$1"
	PORT="$2"
	PASSWD="$3"

	cron
	/etc/init.d/privoxy restart
	/usr/sbin/squid3

	while true
	do
		/usr/bin/ss-tunnel -s ${SERVER} -p ${PORT} -b 0.0.0.0   -l 10000 -k ${PASSWD} -m aes-128-cfb -u -v -L ${SERVER}:${PORT} &
		/usr/bin/ss-local  -s ${SERVER} -p ${PORT} -b 127.0.0.1 -l 10001 -k ${PASSWD} -m aes-128-cfb -u &
		sleep 1200
		jobs -l | grep ss- | awk '{print $2}' | xargs kill
		fg
	done
} >>/ss/ss.log 2>&1
