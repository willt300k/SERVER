# ==========================================
#      🚀 WEBTOP + NGROK REMOTE TUNNEL
#            ✨ VPS ON RAILWAY ✨
# ==========================================
FROM linuxserver/webtop:latest
USER root

# Cài đặt công cụ và tải ngrok từ GitHub Release (Ổn định nhất)
RUN apk update && apk add --no-cache curl wget netcat-openbsd bash tar && \
    curl -Lo /tmp/ngrok.tgz https://github.com/ngrok/ngrok-go/releases/download/v3.3.5/ngrok-v3-stable-linux-amd64.tgz && \
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
# Railway sẽ lấy NGROK_AUTHTOKEN từ Variables \
ngrok config add-authtoken ${NGROK_AUTHTOKEN}; \
\
echo '------------------------------------------'; \
echo '👇 LINK TRUY CẬP CỦA BẠN:'; \
ngrok http 3000 --log stdout & \
\
sleep 10; \
echo '------------------------------------------'; \
\
while true; do echo OK | nc -l -p 8080; done"]
