FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt update && apt install -y --no-install-recommends \
    openbox \
    tigervnc-standalone-server \
    novnc websockify \
    xterm \
    dbus-x11 \
    x11-xserver-utils \
    tint2 \
    pcmanfm \
    curl wget ca-certificates \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vnc

RUN echo '#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
openbox-session & \n\
tint2 & \n\
pcmanfm --desktop & \n\
xterm' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

EXPOSE 6080 5901

CMD bash -c "\
    rm -f /tmp/.X1-lock /tmp/.X11-unix/X1; \
    Xtigervnc :1 \
    -geometry 1024x768 \
    -depth 24 \
    -localhost no \
    -SecurityTypes None \
    -AlwaysShared & \
    sleep 2; \
    websockify --web=/usr/share/novnc/ 6080 localhost:5901"
