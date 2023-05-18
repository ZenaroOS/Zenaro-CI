#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

ADDED_REPOS=($(jq -r "[(.all.include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/repos.json))
REMOVED_REPOS=($(jq -r "[(.all.exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/repos.json))
INCLUDED_PACKAGES=($(jq -r "[(.all.include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/packages.json))
EXCLUDED_PACKAGES=($(jq -r "[(.all.exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/packages.json))

SCRIPTS=$(echo -e "$(yq '.scripts[]' < /tmp/scripts.yml)")

echo "-- Running scripts from /tmp/scripts.yml"
for script in $SCRIPTS; do
	echo "Running ${script}" && \
	/tmp/scripts/$script; \
done

if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    EXCLUDED_PACKAGES=($(rpm -qa --queryformat='%{NAME} ' ${EXCLUDED_PACKAGES[@]}))
fi

echo "-- Adding RPM-FUSION RPMS --"
wget -P /tmp/rpms \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_MAJOR_VERSION}.noarch.rpm

echo "---"

echo "-- Repositories Management --"

if [[ "${#ADDED_REPOS[@]}" -gt 0 && "${#REMOVED_REPOS[@]}" -eq 0 ]]; then
	wget -P /etc/yum.repos.d/ \
		${ADDED_REPOS[@]}
fi
echo "---"

echo "Installing RPM-FUSION RPMS"
rpm-ostree install \
    /tmp/rpms/*.rpm \
    fedora-repos-archive

echo "---"

echo " -- Packages Management --"

if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -eq 0 ]]; then
    rpm-ostree install \
        ${INCLUDED_PACKAGES[@]}

elif [[ "${#INCLUDED_PACKAGES[@]}" -eq 0 && "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]}

elif [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]} \
        $(printf -- "--install=%s " ${INCLUDED_PACKAGES[@]})

else
    echo "No packages to install."

fi

echo "---"
