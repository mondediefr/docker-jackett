FROM xataz/mono:5

ARG JACKETT_VER=0.8.499

ENV UID=991 \
    GID=991

LABEL description="Jackett based on alpine" \
      tags="latest 0.8.499 0.8 0" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="2017120901"

RUN apk add --no-cache wget \
            libcurl \
            ca-certificates \
            s6 \
            su-exec \
    && wget https://github.com/Jackett/Jackett/releases/download/v${JACKETT_VER}/Jackett.Binaries.Mono.tar.gz -O /tmp/Jackett.Binaries.Mono.tar.gz \
    && wget https://curl.haxx.se/ca/cacert.pem -O /tmp/cacert.pem \
    && cert-sync /tmp/cacert.pem \
    && tar xzf /tmp/Jackett.Binaries.Mono.tar.gz -C /usr \
    && apk del --no-cache wget \
    && rm -rf /tmp/*

EXPOSE 9117

COPY rootfs /
RUN chmod +x /usr/local/bin/startup

ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["s6-svscan", "/etc/s6.d"]
