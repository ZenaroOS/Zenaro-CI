#!/bin/sh

set -ouex pipefail

cd /tmp

git clone --recursive https://github.com/Vanilla-OS/apx.git

cd apx

GOCACHE=/tmp/cache/go-build GOENV=/tmp/config/go/env GOMODCACHE=/tmp/go/pkg/mod GOPATH=/tmp/go make build

rm /tmp/apx/distrobox/install

cp /tmp/customs/distrobox.sh /tmp/apx/distrobox/install

make install DESTDIR="" PREFIX=usr

make install-manpages DESTDIR="" PREFIX=usr
