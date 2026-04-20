FROM --platform=linux/amd64 alpine:3.19

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

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
    adwaita-icon-theme

# Setup VNC dan noVNC
RUN mkdir -p /root/.vnc && \
    echo "#!/bin/bash" > /root/.vnc/xstartup && \
    echo "openbox-session &" >> /root/.vnc/xstartup && \
    echo "firefox-esr &" >> /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup && \
    touch /root/.Xauthority

# Cleanup
RUN rm -rf /var/cache/apk/*

EXPOSE 5901 6080

CMD bash -c "vncserver :1 -localhost no -SecurityTypes None -geometry 1280x720 --I-KNOW-THIS-IS-INSECURE && \
    websockify -D --web=/usr/share/novnc/ 6080 localhost:5901 && \
    tail -f /dev/null"
