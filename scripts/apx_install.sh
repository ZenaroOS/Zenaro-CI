#!/bin/sh

set -ouex pipefail

cd /tmp

mkdir /tmp/cache

git clone --recursive https://github.com/Vanilla-OS/apx.git

cd apx

sudo make build

make install PREFIX=usr

make install-manpages PREFIX=usr
