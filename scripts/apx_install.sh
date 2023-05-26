#!/bin/sh

set -ouex pipefail

export HOME=/tmp 

cd /tmp

ln -sf /usr/lib/golang/bin/go /usr/bin/go

git clone --recursive https://github.com/Vanilla-OS/apx.git

cd apx

sudo make build

make install PREFIX=usr

make install-manpages PREFIX=usr
