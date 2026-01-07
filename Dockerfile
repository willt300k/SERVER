FROM linuxserver/webtop:latest
USER root

# Cài đặt công cụ
RUN apk update && apk add --no-cache curl wget netcat-openbsd bash tar

# Tải ngrok chuẩn (Link bNyj1mQVY4c)
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xzf ngrok-v3-stable-linux-amd64.tgz && \
    mv ngrok /usr/local/bin/ && \
    rm ngrok-v3-stable-linux-amd64.tgz

ENV TZ=Asia/Ho_Chi_Minh
EXPOSE 3000
EXPOSE 8080

# Sửa lỗi: Chạy ngrok trực tiếp bằng cờ --authtoken trong lệnh khởi động
# Điều này giúp bỏ qua bước 'ngrok config' vốn hay bị lỗi quyền ghi trên Railway
CMD ["bash","-c","\
echo '🖥️ ĐANG KHỞI ĐỘNG WEBTOP...'; \
/init & \
sleep 15; \
echo '🌐 ĐANG MỞ TUNNEL NGROK...'; \
# Chạy thẳng tunnel kèm token, không cần ghi file config \
ngrok http 3000 --authtoken 1zix6Xh9BPBRvIrrY85S2L3djWY_4ZzHtRzfJ2XnbyBJGCWMp --log stdout & \
\
echo '✅ VPS ĐÃ SẴN SÀNG. KIỂM TRA LINK Ở DƯỚI:'; \
while true; do echo OK | nc -l -p 8080; done"]
