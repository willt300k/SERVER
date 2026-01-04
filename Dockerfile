# ==========================================
#      🚀 WEBTOP + NGROK REMOTE TUNNEL
#            ✨ VPS ON RAILWAY ✨
# ==========================================
FROM linuxserver/webtop:latest
USER root

# Cài đặt các công cụ cần thiết
RUN apk update && apk add --no-cache curl wget netcat-openbsd bash tar

# Sử dụng link ngrok chính xác mà bạn đã cung cấp
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xzf ngrok-v3-stable-linux-amd64.tgz && \
    mv ngrok /usr/local/bin/ && \
    rm ngrok-v3-stable-linux-amd64.tgz

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
# Lấy token từ tab Variables của Railway \
ngrok config add-authtoken ${NGROK_AUTHTOKEN}; \
\
echo '------------------------------------------'; \
echo '👇 ĐANG MỞ TUNNEL (XEM LINK BÊN DƯỚI):'; \
ngrok http 3000 --log stdout & \
\
sleep 10; \
echo '------------------------------------------'; \
\
# Giữ Railway không bị tắt \
while true; do echo OK | nc -l -p 8080; done"]
