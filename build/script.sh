#! /bin/sh
set -oeux pipefail

echo "-- Running scripts from /tmp/scripts.json"
echo "${SCRIPTS}"
for script in $SCRIPTS; do
	echo "Running ${script}" && \
	/tmp/scripts/$script; \
done
