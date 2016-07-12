#!/usr/bin/python2.7
import os
import sys
config_prefix = '''
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
        balance first'''
config_template = "\n        server server%s %s:%s check port 22 maxconn 2000"

# Check params
if len(sys.argv) != 4:
    raise Error("in sufficient argument!")

server_list = sys.argv[1].split(",")
port = sys.argv[2]
password = sys.argv[3]

# Generate haproxy config
config = config_prefix
for i, item in enumerate(server_list):
    config += config_template % (i, item, port)
with open('/etc/haproxy/haproxy.cfg', 'w') as f:
    f.write(config) 

# Generate shadowsocks config
config = '''
{
    "server":"%s",
    "server_port":%s,
    "local_port":10001,
    "password":"%s",
    "method": "aes-256-cfb-auth",
    "timeout":600
}
''' % (server_list[0], port, password)
with open('/root/gopath/bin/config.json', 'w') as f:
    f.write(config) 

# Start services
os.system("cron")
os.system("/etc/init.d/haproxy start")
os.system("/etc/init.d/privoxy restart")
os.system("/usr/sbin/squid3")
os.system("bash -c 'cd /root/gopath/bin/;./shadowsocks-local -d >>/ss/ss.log'")

