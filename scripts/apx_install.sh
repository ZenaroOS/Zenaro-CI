#!/bin/sh

set -ouex pipefail

export GOCACHE="/tmp/.cache/go-build"
export GOENV="/tmp/config/go/env"
#export GOPATH="/tmp/go"
#export GOMODCACHE="${GOPATH}/pkg/mod"

cd /tmp

export PATH=$PATH:/usr/lib/golang/bin

git clone --recursive https://github.com/Vanilla-OS/apx.git

cd apx

sudo make build

make install PREFIX=usr

make install-manpages PREFIX=usr
