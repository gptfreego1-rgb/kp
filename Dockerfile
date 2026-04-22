FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal GUI + VNC + noVNC
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

# Setup VNC password
RUN mkdir -p /root/.vnc && \
    printf "password\npassword\n\n" | vncpasswd && \
    chmod 600 /root/.vnc/passwd

# Startup GUI
RUN echo '#!/bin/sh\nopenbox-session &\ntint2 &\npcmanfm --desktop &' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

EXPOSE 6080 5901

CMD bash -c "\
    Xtigervnc :1 \
    -geometry 1024x768 \
    -depth 24 \
    -rfbauth /root/.vnc/passwd \
    -localhost yes & \
    websockify --web=/usr/share/novnc/ 6080 localhost:5901"
