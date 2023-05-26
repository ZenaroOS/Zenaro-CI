cd /tmp

export PATH=$PATH:/usr/lib/golang/bin

git clone --recursive https://github.com/Vanilla-OS/apx.git

cd apx

mkdir /root/.cache

make build

make install PREFIX=usr

make install-manpages PREFIX=usr
