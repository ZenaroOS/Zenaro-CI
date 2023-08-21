#!/bin/sh

set -ouex pipefail

ln -sf /usr/lib/golang/bin/go /usr/bin/go
ln -sf /usr/lib/golang/bin/gofmt /usr/bin/gofmt

echo "export LD=gold" > /etc/profile.d/set-env.sh
chmod +x /etc/profile.d/set-env.sh

SCRIPTS=$(echo -e "$(yq '.finalinstall[]' < /tmp/scripts.yml)")

echo "-- Running scripts from /tmp/scripts.yml"
for script in $SCRIPTS; do
	echo "Running ${script}" && \
	/tmp/scripts/$script; \
done

systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer

systemctl --global enable flatpak-user-update.timer

if [[ $IMAGE_NAME == "hypersthene" || $IMAGE_NAME == "sphene" ]]; then
	sed -i '171s/kitty-open.desktop;//' /usr/share/applications/mimeinfo.cache
	sed  -i '12s+inode/directory;++' /usr/share/applications/kitty-open.desktop
fi

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf
cp /usr/share/ublue-os/just/ublue-os-just.sh /etc/profile.d/
