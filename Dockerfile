FROM --platform=linux/amd64 alpine:3.19

ENV DISPLAY=:1
ENV USER=root
ENV VNC_PASSWD=""

# Install paket minimal
RUN apk update && apk add --no-cache \
    openbox \
    xfce4-terminal \
    firefox-esr \
    tigervnc \
    novnc \
    websockify \
    bash \
    sudo \
    dbus-x11 \
    xauth \
    tzdata \
    curl \
    git \
    font-noto \
    adwaita-icon-theme \
    xrandr

# Setup VNC dan noVNC
RUN mkdir -p /root/.vnc && \
    echo "#!/bin/bash" > /root/.vnc/xstartup && \
    echo "openbox-session &" >> /root/.vnc/xstartup && \
    echo "firefox-esr &" >> /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup && \
    touch /root/.Xauthority && \
    echo "" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Cleanup
RUN rm -rf /var/cache/apk/*

EXPOSE 5901 6080

CMD bash -c "vncserver :1 -geometry 1280x720 -depth 24 -localhost no -SecurityTypes None && \
    websockify -D --web=/usr/share/novnc/ 0.0.0.0:6080 localhost:5901 && \
    tail -f /dev/null"
