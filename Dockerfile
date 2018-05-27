FROM resin/raspberry-pi-debian
MAINTAINER tynor88

RUN [ "cross-build-start" ]

# set version for s6 overlay
ARG OVERLAY_VERSION="v1.21.4.0"
ARG OVERLAY_ARCH="armhf"

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="tynor88"

# set package verion resilio-sync
ARG SYNC_ARCH="arm"
ARG SYNC_VER="stable"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/root" \
LANGUAGE="en_US.UTF-8" \
LANG="en_US.UTF-8" \
TERM="xterm"

RUN \
 echo "**** install packages ****" && \
 apt-get install -y \
	       curl \
	       tzdata && \
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
 echo "**** create abc user and make our folders ****" && \
 useradd -u 911 -U -d /config -s /bin/false abc && \
 usermod -G users abc && \
 mkdir -p \
        /app \
        /config \
        /defaults && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	       /tmp/* \
	       /var/lib/apt/lists/* \
	       /var/tmp/*
	       

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8888 55555
VOLUME /config /downloads /sync

RUN [ "cross-build-end" ] 

ENTRYPOINT ["/init"]
