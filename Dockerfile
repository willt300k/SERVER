FROM linuxserver/webtop:latest
USER root

RUN apk update && apk add --no-cache curl wget netcat-openbsd bash tar

RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xzf ngrok-v3-stable-linux-amd64.tgz && \
    mv ngrok /usr/local/bin/ && \
    rm ngrok-v3-stable-linux-amd64.tgz

ENV TZ=Asia/Ho_Chi_Minh
EXPOSE 3000
EXPOSE 8080

CMD ["bash","-c","\
echo '🖥️  WEBTOP ĐANG KHỞI ĐỘNG...'; \
/init & sleep 5; \
\
if [ -z \"$NGROK_AUTHTOKEN\" ]; then \
  echo '❌ LỖI: Thiếu NGROK_AUTHTOKEN trong Variables!'; \
  exit 1; \
fi; \
\
echo '🌐 ĐANG KẾT NỐI NGROK...'; \
# Ép ngrok dùng file config trong thư mục /tmp để tránh lỗi quyền ghi \
echo 'authtoken: ' $NGROK_AUTHTOKEN > /tmp/ngrok.yml; \
\
echo '------------------------------------------'; \
echo '👇 LINK TRUY CẬP CỦA BẠN:'; \
# Chạy ngrok trực tiếp với file config vừa tạo \
ngrok http 3000 --config /tmp/ngrok.yml --log stdout & \
\
sleep 10; \
echo '------------------------------------------'; \
\
while true; do echo OK | nc -l -p 8080; done"]
