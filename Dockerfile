FROM alpine:edge

ENV CONSUL_VERSION 0.6.0
ADD https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip /tmp/consul.zip
RUN apk --update add bash ca-certificates curl \
    && curl -Ls https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk > /tmp/glibc-2.21-r2.apk \
    && apk add --allow-untrusted /tmp/glibc-2.21-r2.apk \
    && rm -rf /tmp/glibc-2.21-r2.apk /var/cache/apk/* \
    && cd /bin \
    && unzip /tmp/consul.zip \
    && chmod +x /bin/consul \
    && rm /tmp/consul.zip \
    && mkdir -p /var/lib/consul/data \
    && mkdir -p /etc/consul/ \
    && apk del curl \
    && rm -rf /var/cache/apk/*

COPY consul.json /etc/consul/
COPY run-consul /bin/

VOLUME /var/lib/consul/data
EXPOSE 53 53/udp 8300 8301 8301/udp 8302 8302/udp 8400 8500
CMD ["run-consul"]
