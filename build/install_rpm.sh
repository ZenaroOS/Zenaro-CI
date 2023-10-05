#! /bin/sh
set -oeux pipefail

echo "Installing RPM-FUSION RPMS"
rpm-ostree install \
    /tmp/rpms/*.rpm \
    fedora-repos-archive

echo "---"

