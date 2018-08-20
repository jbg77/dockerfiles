#!/bin/sh

init_volumes() {
    mkdir -p /data/torrents
    mkdir -p /data/.session
    mkdir -p /config
    rm -f /data/.session/rtorrent.lock
}

customize_rtorrent() {
    if [ -n "$RTORRENT_DOWNLOAD_RATE" ]; then
        echo "download_rate = $RTORRENT_DOWNLOAD_RATE" >> /tmp/.rtorrent.rc
    fi
    if [ -n "$RTORRENT_UPLOAD_RATE" ]; then
        echo "upload_rate = $RTORRENT_UPLOAD_RATE" >> /tmp/.rtorrent.rc
    fi
}

fix_permissions() {
    groupadd -f -g $GID shabadadoo
    id -un $UID > /dev/null 2>&1 || useradd -u $UID -g $GID kirakira
    chown -R $UID:$GID /config /data /tmp
}

session_openvpn() {
    
        screen -d openvpn client.ovpn
    
}

start_sessions() {
    cron;
    exec >/dev/tty 2>/dev/tty </dev/tty; \
        screen -S rtorrent -d -m su - `id -un $UID` -c "(HOME='/tmp'; rtorrent)"; \
        screen -S flood -d -m npm start; \
        session_openvpn;
}

init_volumes
customize_rtorrent
fix_permissions
start_sessions
