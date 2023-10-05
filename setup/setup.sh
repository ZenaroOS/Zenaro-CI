#! /bin/sh

if [[ -f /tmp/setup/zenaro.pub ]]; then
	cp /tmp/setup/zenaro.pub /usr/etc/pki/containers
	cp -f /tmp/setup/policy.json /usr/etc/containers
elif [[ -f ./zenaro.pub ]]; then
	cp ./zenaro.pub /etc/pki/containers
	cp -f ./policy.json /etc/containers
else
	echo "No GPG Key found"
fi
