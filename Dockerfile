FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
    fluxbox \
    tigervnc-standalone-server \
    novnc \
    websockify \
    dbus-x11 \
    x11-xserver-utils \
    xterm \
    ca-certificates \
    curl \
    wget \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vnc
RUN echo "fluxbox &" > /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

EXPOSE 5901
EXPOSE 6080

CMD bash -c "\
vncserver :1 -geometry 1024x768 -depth 24 -SecurityTypes None && \
websockify --web=/usr/share/novnc/ 6080 localhost:5901 \
"
