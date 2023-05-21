#!/bin/sh

set -ouex pipefail

RELEASE=711

systemctl enable rpm-ostred-automatic.timer
systemctl enable appimaged.service
systemctl enable flatpak-system-update.timer

systemctl --global enable flatpak-user-update.timer

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf

if [[ -f /usr/lib/appimaged/appimaged-${RELEASE}-x86_64.AppImage ]]; then 
	wget -P /usr/lib/appimaged/ \
		https://github.com/probonopd/go-appimage/releases/download/continuous/appimaged-${RELEASE}-x86_64.AppImage
