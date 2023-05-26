#!/bin/sh

set -ouex pipefail

ln -sf /usr/bin/go /usr/lib/golang/bin/go
ln -sf /usr/bin/gofmt /usr/lib/golang/bin/gofmt

SCRIPTS=$(echo -e "$(yq '.finalinstall[]' < /tmp/scripts.yml)")

echo "-- Running scripts from /tmp/scripts.yml"
for script in $SCRIPTS; do
	echo "Running ${script}" && \
	/tmp/scripts/$script; \
done

systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer

systemctl --global enable flatpak-user-update.timer

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf
