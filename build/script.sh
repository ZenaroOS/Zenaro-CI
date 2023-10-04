#! /bin/sh
set -oeux pipefail

SCRIPTS="($(jq -r '.scripts[]' /tmp/scripts.json))"

echo "-- Running scripts from /tmp/scripts.json"
echo "${SCRIPTS}"
for script in $SCRIPTS; do
	echo "Running ${script}" && \
	/tmp/scripts/$script; \
done
