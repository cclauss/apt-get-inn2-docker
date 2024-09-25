#!/bin/sh

if [ ! -f /etc/news/key.pem ]; then
    echo "Generating SSL key"
    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
        -keyout /etc/news/key.pem \
        -out /etc/news/cert.pem \
        -subj "/CN=localhost" && \
    chown news:news /etc/news/key.pem /etc/news/cert.pem
fi

# Fake out rc.news so it puts innd into the foreground like it would for systemd
export LISTEN_PID=1

# Drop privileges and start the news server
exec setpriv \
    --reuid=news \
    --regid=news \
    --init-groups \
    --inh-caps=-all \
    /usr/lib/news/bin/rc.news
