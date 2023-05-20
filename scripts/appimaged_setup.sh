#! /bin/sh
RELEASE=711

sudo tee <<EOF
[Unit]
Description=AppImage system integration daemon
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/lib/appimaged/appimaged-${RELEASE}-x86_64.AppImage

LimitNOFILE=65536

RestartSec=3
Restart=always

Environment=LAUNCHED_BY_SYSTEMD=1

[Install]
WantedBy=default.target
EOF
