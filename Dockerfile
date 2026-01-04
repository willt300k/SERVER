# ==========================================
#      🚀 WEBTOP + NGROK REMOTE TUNNEL
#            ✨ VPS ON RAILWAY ✨
# ==========================================
FROM linuxserver/webtop:latest
USER root

# Cài đặt các công cụ cần thiết và ngrok bằng link dự phòng ổn định
RUN apk update && \
    apk add --no-cache curl wget netcat-openbsd bash tar && \
    wget -q https://bin.equinox.io/c/bPR9B2h3Y6h/ngrok-v3-stable-linux-amd64.tgz -O ngrok.tgz || \
    wget -q https://github.com/ngrok/ngrok-go/releases/download/v3.3.5/ngrok-v3-stable-linux-amd64.tgz -O ngrok.tgz || \
    curl -Lo ngrok.tgz https://bin.equinox.io/c/bPR9B2h3Y6h/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xzf ngrok.tgz -C /usr/local/bin && \
    rm ngrok.tgz

ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Ho_Chi_Minh

EXPOSE 3000
EXPOSE 8080

CMD ["bash","-c","\
echo '🖥️  WEBTOP ĐANG KHỞI ĐỘNG...'; \
/init & sleep 5; \
\
echo '🌐 ĐANG KẾT NỐI NGROK...'; \
ngrok config add-authtoken ${NGROK_AUTHTOKEN}; \
\
echo '------------------------------------------'; \
echo '👇 ĐANG LẤY LINK TRUY CẬP...'; \
# Chạy ngrok và in log ra stdout \
ngrok http 3000 --log stdout & \
\
# Đợi 5 giây để ngrok kết nối và in thêm thông báo \
sleep 8; \
echo '👉 HÃY TÌM DÒNG: url=https://... TRONG LOG TRÊN'; \
echo '------------------------------------------'; \
\
while true; do echo OK | nc -l -p 8080; done"]
