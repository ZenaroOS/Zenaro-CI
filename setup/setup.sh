#! /bin/sh

if [[ -f /tmp/setup/zenaro.pub ]]; then
	cp /tmp/setup/zenaro.pub -o /usr/etc/pki/containers
	cp -f /tmp/setup/policy.json /usr/etc/containers
else
	curl  -o /etc/pki/containers/zenaro.pub https://raw.githubusercontent.com/ZenaroDev/container-devel/devel/cosign.pub
	wget -P /etc/containers/policy.json https://github.com/ZenaroDev/container-devel/raw/devel/setup/policy.json
fi
