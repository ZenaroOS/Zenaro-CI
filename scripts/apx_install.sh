#!/bin/sh

set -ouex pipefail

cd /tmp

export PATH=$PATH:/usr/lib/golang/bin

git clone --recursive https://github.com/Vanilla-OS/apx.git

cd apx

#rm /root

#mkdir /root
#mkdir /root/.cache

sudo make build

make install PREFIX=usr

make install-manpages PREFIX=usr
