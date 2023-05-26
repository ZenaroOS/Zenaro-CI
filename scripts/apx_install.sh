cd /tmp

git clone --recursive https://github.com/Vanilla-OS/apx.git

cd apx

make build

make install PREFIX=usr

make install-manpages PREFIX=usr
