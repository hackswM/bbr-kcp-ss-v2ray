FROM alpine:3.10
ARG VERSION=4.20.0
LABEL maintainer="zgist" \
        org.label-schema.name="V2Ray" \
        org.label-schema.version=$VERSION

# Let's roll
RUN set -xe && \
    apk add --no-cache ca-certificates curl && \
    mkdir -p /usr/bin/v2ray /etc/v2ray /tmp/v2ray /var/log/v2ray && \
    curl -sSLo /tmp/v2ray/v2ray-linux-64.zip https://github.com/v2ray/v2ray-core/releases/download/v$VERSION/v2ray-linux-64.zip && \
    unzip /tmp/v2ray/v2ray-linux-64.zip -d /tmp/v2ray/ && \
    mv /tmp/v2ray/v2ray /usr/bin/v2ray/ && \
    mv /tmp/v2ray/v2ctl /usr/bin/v2ray/ && \
    mv /tmp/v2ray/geoip.dat /usr/bin/v2ray/ && \
    mv /tmp/v2ray/geosite.dat /usr/bin/v2ray/ && \
    apk del curl && \
    rm -rf /tmp/v2ray 
ENV PATH /usr/bin/v2ray:$PATH
COPY /config/v2.json /etc/v2ray/v2.json

RUN apk update && apk add bash
# install rinetd
COPY /server/rinetd_bbr /usr/bin
COPY /config/rinetd.conf /etc
RUN set -ex \
    && apk add iptables \
    && chmod +x /usr/bin/rinetd_bbr
	
# install socks5
COPY /server/socks5 /usr/bin
RUN set -ex \
    && chmod +x /usr/bin/socks5
	
# install kcptun
COPY /server/kcp-server	/usr/bin
COPY /config/kcptun_config.json /opt
RUN set -ex \
    && chmod +x /usr/bin/kcp-server

# install ss
COPY /server/ss /usr/bin
COPY /config/ss.json /opt
RUN set -ex \
    && chmod +x /usr/bin/ss
	
# install supervisor
RUN apk add supervisor \
    && mkdir -p /etc/supervisord.d	
COPY /config/supervisord.conf /etc
COPY /config/process.conf /etc/supervisord.d
STOPSIGNAL SIGTERM
EXPOSE 8888 6666 45678
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

