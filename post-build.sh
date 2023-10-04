#!/bin/sh

set -ouex pipefail

ln -sf /usr/lib/golang/bin/go /usr/bin/go
ln -sf /usr/lib/golang/bin/gofmt /usr/bin/gofmt

ln -sf /usr/bin/ld.gold /usr/bin/ld

systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer

systemctl --global enable flatpak-user-update.timer

if [[ IMAGE_NAME == "gahnite" ]]; then
	sed -i 's/Silverblue/Gahnite/' /usr/lib/os-release
	sed -i '/^VARIANT_ID/s/silverblue/gahnite/' /usr/lib/os-release
elif [[ IMAGE_NAME == "sphene" ]]; then
	sed -i 's/Sericea/Sphene/' /usr/lib/os-release
	sed -i 	'/^VARIANT_ID/s/sericea/sphene/' /usr/lib/os-release
	sed -i '171s/kitty-open.desktop;//' /usr/share/applications/mimeinfo.cache
	sed  -i '12s+inode/directory;++' /usr/share/applications/kitty-open.desktop
fi

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf
cp -r /usr/share/ublue-os/just /etc/
cp /usr/share/ublue-os/justfile /etc/justfile
