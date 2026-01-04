# ==========================================
#   🚀 WEBTOP + NGROK HTTP (BROWSER)
#   ✅ FIX TRIỆT ĐỂ SYNTAX + PID 1
# ==========================================
FROM linuxserver/webtop:latest

USER root

# Install ngrok
RUN apk update && \
    apk add --no-cache curl tar bash && \
    wget -qO- https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz \
    | tar xz -C /usr/local/bin

ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Ho_Chi_Minh

EXPOSE 3000

# -------- s6 service: ngrok --------
RUN mkdir -p /etc/services.d/ngrok && \
cat <<'EOF' > /etc/services.d/ngrok/run
#!/bin/sh
set -e

echo "[ngrok] starting"
ngrok config add-authtoken "$NGROK_AUTHTOKEN"
exec ngrok http 3000
EOF
RUN chmod +x /etc/services.d/ngrok/run

# MUST be PID 1
CMD ["/init"]
