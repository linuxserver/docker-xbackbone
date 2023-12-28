# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.19

# set version label
ARG BUILD_DATE
ARG VERSION
ARG XBACKBONE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="gilbn"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    php83-ftp \
    php83-gd \
    php83-intl \
    php83-ldap \
    php83-mysqli \
    php83-pdo_mysql \
    php83-pdo_sqlite \
    php83-sqlite3 \
    php83-tokenizer && \
  echo "**** install xbackbone ****" && \
    mkdir -p /app/www/public && \
  if [ -z ${XBACKBONE_RELEASE+x} ]; then \
    XBACKBONE_RELEASE=$(curl -sX GET "https://api.github.com/repos/SergiX44/XBackBone/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/xbackbone.zip -L \
    "https://github.com/SergiX44/XBackBone/releases/download/${XBACKBONE_RELEASE}/release-v${XBACKBONE_RELEASE}.zip" && \
  unzip -q -o /tmp/xbackbone.zip -d /app/www/public/ && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    $HOME/.cache

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
