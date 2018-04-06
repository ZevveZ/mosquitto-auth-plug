FROM alpine:3.6

RUN echo http://mirrors.ustc.edu.cn/alpine/v3.6/main > /etc/apk/repositories; \
echo http://mirrors.ustc.edu.cn/alpine/v3.6/community >> /etc/apk/repositories

RUN apk update
RUN apk --no-cache add mosquitto && \
    mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log && \
    cp /etc/mosquitto/mosquitto.conf /mosquitto/config && \
    chown -R mosquitto:mosquitto /mosquitto

# COPY docker-entrypoint.sh /
# ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]

RUN apk --no-cache add --upgrade apk-tools
RUN apk --no-cache add git util-linux-dev c-ares-dev build-base mariadb-dev mosquitto-dev

RUN mkdir -p /build/mosquitto-auth-plug
ADD . /build/mosquitto-auth-plug/
RUN cd /build/mosquitto-auth-plug && make