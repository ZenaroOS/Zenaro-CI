#! /bin/sh
set -oeux pipefail

echo "-- Adding EXTRA RPMS --"
wget -P /tmp/rpms \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
    https://github.com/rpmsphere/noarch/raw/master/r/rpmsphere-release-${FEDORA_MAJOR_VERSION}-1.noarch.rpm
echo "---"


