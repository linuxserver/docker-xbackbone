FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.15

# set version label
ARG BUILD_DATE
ARG VERSION
ARG XBACKBONE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="gilbn"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    curl \
    php8 \
    php8-sqlite3 \
    php8-mysqli \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-gd \
    php8-json \
    php8-fileinfo \
    php8-zip \
    php8-ftp \
    php8-ldap \
    php8-tokenizer \
    php8-intl && \
  echo "**** install xbackbone ****" && \
    mkdir -p /app/xbackbone && \
  if [ -z ${XBACKBONE_RELEASE+x} ]; then \
    XBACKBONE_RELEASE=$(curl -sX GET "https://api.github.com/repos/SergiX44/XBackBone/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/xbackbone.zip -L \
    "https://github.com/SergiX44/XBackBone/releases/download/${XBACKBONE_RELEASE}/release-v${XBACKBONE_RELEASE}.zip" && \
  unzip -q -o /tmp/xbackbone.zip -d /app/xbackbone/ && \
  echo "**** cleanup ****" && \
  rm -rf \
    /root/.cache \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
