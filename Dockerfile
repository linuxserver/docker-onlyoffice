FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
ARG ONLYOFFICE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=ONLYOFFICE \
    NO_GAMEPAD=true

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/onlyoffice-logo.png && \
  echo "**** install onlyoffice ****" && \
  if [ -z ${ONLYOFFICE_VERSION+x} ]; then \
    ONLYOFFICE_VERSION=$(curl -sX GET "https://api.github.com/repos/ONLYOFFICE/DesktopEditors/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/onlyoffice.deb -L \
    "https://github.com/ONLYOFFICE/DesktopEditors/releases/download/${ONLYOFFICE_VERSION}/onlyoffice-desktopeditors_amd64.deb" && \
  apt-get update && \
  apt-get install -y \
    gsettings-desktop-schemas \
    /tmp/onlyoffice.deb && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
