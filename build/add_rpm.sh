#! /bin/sh
set -oeux pipefail
UNSTABLE=39

if [[ $FEDORA_MAJOR_VERSION == $UNSTABLE ]]; then
	FEDORA_MAJOR_VERSION="rawhide"
fi
echo "-- Adding EXTRA RPMS --"
wget -P /tmp/rpms \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
    https://github.com/rpmsphere/noarch/raw/master/r/rpmsphere-release-${FEDORA_MAJOR_VERSION}-1.noarch.rpm
echo "---"


