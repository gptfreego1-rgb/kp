FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal GUI + VNC
RUN apt update && apt install -y --no-install-recommends \
    openbox \
    tigervnc-standalone-server \
    novnc websockify \
    xterm \
    dbus-x11 \
    firefox \
    curl wget ca-certificates \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Setup VNC
RUN mkdir -p /root/.vnc && \
    echo "#!/bin/sh\nopenbox-session &\nxterm &" > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Expose ports
EXPOSE 5901 6080

CMD bash -c "\
    vncserver :1 -geometry 1024x768 -localhost no -SecurityTypes None && \
    websockify --web=/usr/share/novnc/ 6080 localhost:5901"
