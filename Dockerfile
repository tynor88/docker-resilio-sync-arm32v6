FROM arm32v6/alpine
MAINTAINER tynor88

# set version for s6 overlay
ARG OVERLAY_VERSION="v1.21.4.0"
ARG OVERLAY_ARCH="armhf"

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="tynor88"

# set package verion resilio-sync
ARG SYNC_ARCH="armhf"
ARG SYNC_VER="stable"

# set environment variables
ENV HOME="/root" \
LANGUAGE="en_US.UTF-8" \
LANG="en_US.UTF-8" \
TERM="xterm"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
        curl \
        tar && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
        bash \
        ca-certificates \
        coreutils \
        shadow \
        tzdata && \
 echo "**** add qemu static ****" && \
 curl -o \ 
 qemu-arm-static.tar.gz -L \
        "https://github.com/multiarch/qemu-user-static/releases/download/v2.6.0/qemu-arm-static.tar.gz" && \
 tar xfz \
        /tmp/qemu-arm-static.tar.gz \
        -C /usr/bin/ && \
 echo "**** add s6 overlay ****" && \
 curl -o \
 /tmp/s6-overlay.tar.gz -L \
        "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" && \
 tar xfz \
        /tmp/s6-overlay.tar.gz -C / && \
 echo "**** install resilio-sync ****" && \
 curl -o \
 /tmp/sync.tar.gz -L \
        "https://download-cdn.getsync.com/${SYNC_VER}/linux-${SYNC_ARCH}/resilio-sync_${SYNC_ARCH}.tar.gz" && \
 tar xfz \
        /tmp/sync.tar.gz \
        -C /usr/bin && \
 echo "**** cleanup ****" && \
 rm -rf \
        /tmp/* \

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8888 55555
VOLUME /config /downloads /sync

ENTRYPOINT ["/init"]
