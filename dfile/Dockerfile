FROM ubuntu:14.04
RUN apt-get update && apt-get install -y build-essential autoconf libtool libssl-dev gawk debhelper wget unzip privoxy squid3
RUN cd && wget https://github.com/shadowsocks/shadowsocks-libev/archive/master.zip && unzip master.zip && cd shadowsocks-libev-master/ && dpkg-buildpackage -us -uc && cd && dpkg -i shadowsocks-libev*.deb
RUN sed -i "s#^listen-address.*#listen-address  127.0.0.1:10002#" /etc/privoxy/config && echo 'forward-socks5   /               127.0.0.1:10001 .' >>/etc/privoxy/config
ADD squid.conf /etc/squid3/squid.conf
ADD ss-run.sh /usr/bin/ss-run.sh
ADD ss-rotate.sh /usr/bin/ss-rotate.sh
ADD ss-cron /etc/cron.d/ss-cron
VOLUME /ss
ENTRYPOINT ["/usr/bin/ss-run.sh"]
