# ==========================================
#      🚀 WEBTOP + NGROK REMOTE TUNNEL
#            ✨ VPS ON RAILWAY ✨
# ==========================================
FROM linuxserver/webtop:latest
USER root

# Cài đặt các công cụ cần thiết
RUN apk update && apk add --no-cache curl wget netcat-openbsd bash tar

# Tải ngrok từ link ổn định (v3 stable cho Linux AMD64)
# Nếu link này lỗi, Docker sẽ dừng ngay tại đây để ta biết
RUN curl -Lo /tmp/ngrok.tgz https://bin.equinox.io/c/bPR9B2h3Y6h/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xzf /tmp/ngrok.tgz -C /usr/local/bin && \
    rm /tmp/ngrok.tgz

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
# Sử dụng biến NGROK_AUTHTOKEN từ Railway Variables \
ngrok config add-authtoken ${NGROK_AUTHTOKEN}; \
\
echo '------------------------------------------'; \
echo '👇 LINK TRUY CẬP CỦA BẠN SẼ HIỆN Ở DÒNG URL:'; \
# Chạy ngrok và ép in log ra màn hình \
ngrok http 3000 --log stdout & \
\
# Đợi 10 giây để đảm bảo tunnel đã mở và in link \
sleep 10; \
echo '------------------------------------------'; \
\
while true; do echo OK | nc -l -p 8080; done"]
