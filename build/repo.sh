#! /bin/sh

set -ouex pipefail

ADDED_REPOS=$(jq -r "[(.all.include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/repos.json)
REMOVED_REPOS=$(jq -r "[(.all.exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/repos.json)

echo "-- Repositories Management --"
if [[ "${#ADDED_REPOS[@]}" -gt 0 && "${#REMOVED_REPOS[@]}" -eq 0 ]]; then
	wget -P /etc/yum.repos.d/ \
		${ADDED_REPOS[@]}
fi
echo "---"

