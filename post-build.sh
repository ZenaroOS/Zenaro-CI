#!/bin/sh

set -ouex pipefail

ln -sf /usr/lib/golang/bin/go /usr/bin/go
ln -sf /usr/lib/golang/bin/gofmt /usr/bin/gofmt

ln -sf /usr/bin/ld.gold /usr/bin/ld

SCRIPTS=$(echo -e "$(yq '.finalinstall[]' < /tmp/scripts.yml)")

echo "-- Running scripts from /tmp/scripts.yml"
for script in $SCRIPTS; do
	echo "Running ${script}" && \
	/tmp/scripts/$script; \
done
