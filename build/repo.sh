#! /bin/sh

set -ouex pipefail

source /tmp/build/vars.sh

echo "-- Repositories Management --"
if [[ "${#ADDED_REPOS[@]}" -gt 0 && "${#REMOVED_REPOS[@]}" -eq 0 ]]; then
	wget -P /etc/yum.repos.d/ \
		${ADDED_REPOS[@]}
fi
echo "---"

