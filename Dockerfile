# ==========================================
#   🚀 WEBTOP + NGROK HTTP (BROWSER)
#   ✅ FIX KEEPALIVE + FIX S6 LOOP
# ==========================================
FROM linuxserver/webtop:latest

USER root

# Install ngrok
RUN apk update && \
    apk add --no-cache curl tar bash netcat-openbsd && \
    wget -qO- https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz \
    | tar xz -C /usr/local/bin

ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Ho_Chi_Minh

EXPOSE 3000
EXPOSE 8080

# ----------------------------
# s6 service: ngrok
# ----------------------------
RUN mkdir -p /etc/services.d/ngrok && \
printf '#!/bin/sh\n\
echo \"[ngrok] starting\";\n\
ngrok config add-authtoken \"$NGROK_AUTHTOKEN\";\n\
exec ngrok http 3000\n' \
> /etc/services.d/ngrok/run && chmod +x /etc/services.d/ngrok/run

# ----------------------------
# s6 service: keepalive (FIX)
# ----------------------------
RUN mkdir -p /etc/services.d/keepalive && \
printf '#!/bin/sh\n\
exec sh -c \"while true; do echo OK | nc -l -p 8080; done\"\n' \
> /etc/services.d/keepalive/run && chmod +x /etc/services.d/keepalive/run

# MUST be PID 1
CMD [\"/init\"]
