# ==========================================
#   🚀 WEBTOP + NGROK HTTP (BROWSER)
#   ✅ FIX s6-overlay PID 1
# ==========================================
FROM linuxserver/webtop:latest

USER root

# Install ngrok
RUN apk update && \
    apk add --no-cache curl tar bash && \
    wget -qO- https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz \
    | tar xz -C /usr/local/bin

# Env
ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Ho_Chi_Minh
ENV NGROK_AUTHTOKEN=${NGROK_AUTHTOKEN}

EXPOSE 3000

# -------- s6 service: ngrok (CHỈ exec 1 LỆNH) --------
RUN mkdir -p /etc/services.d/ngrok && \
cat <<'EOF' > /etc/services.d/ngrok/run
#!/bin/sh
echo "[ngrok] starting"
exec ngrok http 3000
EOF
RUN chmod +x /etc/services.d/ngrok/run

# BẮT BUỘC
CMD ["/init"]
