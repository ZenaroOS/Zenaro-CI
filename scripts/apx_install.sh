#!/bin/sh

set -ouex pipefail

cd /tmp

export PATH=$PATH:/usr/lib/golang/bin

git clone --recursive https://github.com/Vanilla-OS/apx.git

cd apx

if [[ -d /root ]]; then
	sudo mkdir /root/.cache
else
	sudo mkdir /root
	sudo mkdir /root/.cache
fi

sudo make build

make install PREFIX=usr

make install-manpages PREFIX=usr
