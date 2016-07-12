FROM ubuntu:14.04
RUN apt-get update
RUN sudo apt-get install -y wget unzip git privoxy squid3 haproxy
ADD CHECKSUM-go1.6.2.linux-amd64 /root/go/CHECKSUM-go1.6.2.linux-amd64

RUN cd ~/go && wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz && sha256sum -c CHECKSUM-go1.6.2.linux-amd64 && tar xf go1.6.2.linux-amd64.tar.gz
RUN cd && mkdir gopath
RUN cd && export GOROOT="$PWD/go/go" && cd gopath && export GOPATH="$PWD" && ~/go/go/bin/go get github.com/alicewww/shadowsocks-go/cmd/shadowsocks-local

RUN sed -i "s#^listen-address.*#listen-address  127.0.0.1:10002#" /etc/privoxy/config && echo 'forward-socks5   /               127.0.0.1:10001 .' >>/etc/privoxy/config
RUN sed -i "s#^ENABLED=0#ENABLED=1#" /etc/default/haproxy
ADD squid.conf /etc/squid3/squid.conf
ADD ss-run.sh /usr/bin/ss-run.sh
ADD ss-rotate.sh /usr/bin/ss-rotate.sh
ADD ss-cron /etc/cron.d/ss-cron
VOLUME /ss
ENTRYPOINT ["/usr/bin/ss-run.sh"]
