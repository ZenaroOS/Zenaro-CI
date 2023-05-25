#!/bin/sh

set -ouex pipefail

RELEASE=711

systemctl enable rpm-ostred-automatic.timer
systemctl enable appimaged.service
systemctl enable flatpak-system-update.timer

systemctl --global enable flatpak-user-update.timer

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf
