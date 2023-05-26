#!/bin/sh

set -ouex pipefail

cd /tmp

git clone --recursive https://github.com/Vanilla-OS/apx.git

cd apx

GOCACHE=/tmp/cache/go-build GOENV=/tmp/config/go/env GOMODCACHE=/tmp/go/pkg/mod GOPATH=/tmp/go make build

rm /tmp/apx/distrobox/install
tee /tmp/apx/distrobox/install <<EOF
#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-only
#
# This file is part of the distrobox project: https://github.com/89luca89/distrobox
#
# Copyright (C) 2021 distrobox contributors
#
# distrobox is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.
#
# distrobox is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with distrobox; if not, see <http://www.gnu.org/licenses/>.

# POSIX

next=0
verbose=0
version=1.4.2.1

# Print usage to stdout.
# Arguments:
#   None
# Outputs:
#   print usage with examples.
show_help() {
	cat << EOF
install --prefix /usr/local

Options:
	--prefix/-P:		base bath where all files will be deployed (default /usr/local if root, ~/.local if not)
	--next/-N:		install latest development version from git, instead of the latest stable release.
	--help/-h:		show this message
	-v:			show more verbosity
EOF
}

# Parse arguments
while :; do
	case $1 in
		-h | --help)
			# Call a "show_help" function to display a synopsis, then exit.
			show_help
			exit
			;;
		-v | --verbose)
			shift
			verbose=1
			;;
		-N | --next)
			if [ -n "$2" ]; then
				shift
				next=1
			fi
			;;
		-P | --prefix)
			if [ -n "$2" ]; then
				prefix="$2"
				shift
				shift
			fi
			;;
		*) # Default case: If no more options then break out of the loop.
			break ;;
	esac
done

if  [ -z "${prefix}" ]; then
	prefix="/usr/local"
	# in case we're not root, just default to the home directory
	if [ "$(id -u)" -ne 0 ]; then
		prefix="${HOME}/.local"
	fi
fi
dest_path="${prefix}/bin"
man_dest_path="${prefix}/share/man/man1"
icon_dest_path="${prefix}/share/icons"
completion_dest_path="${prefix}/share/bash-completion/completions/"

set -o errexit
set -o nounset
# set verbosity
if [ "${verbose}" -ne 0 ]; then
	set -o xtrace
fi

# get current dir
curr_dir=$(dirname "$0")
cd "${curr_dir}" || exit 1

# if files are available, install files in dest directory
# else download targz and uncompress it
if [ -e "${curr_dir}/distrobox-enter" ]; then
	for file in distrobox*; do
		if ! install -D -m 0755 -t "${dest_path}" "${file}"; then
			printf >&2 "Do you have permission to write to %s?\n" "${dest_path}"
			exit 1
		fi
	done
	if [ -e "man" ]; then
		for file in man/man1/*; do
			install -D -m 0644 -t "${man_dest_path}" "${file}"
		done
	fi
	if [ -e "completions" ]; then
		for file in completions/*; do
			install -D -m 0644 -t "${completion_dest_path}" "${file}"
		done
	fi
	if [ -e terminal-distrobox-icon.png ]; then
		install -D -m 0644 -t "${icon_dest_path}" terminal-distrobox-icon.png
	fi
else
	printf >&2 "\033[1;31m Checking dependencies...\n\033[0m"
	# check that we have base dependencies
	if ! { command -v curl > /dev/null || command -v wget > /dev/null; } || ! command -v tar > /dev/null; then
		printf >&2 "Online install depends on tar and either curl or wget\n"
		printf >&2 "Ensure you have all dependencies installed.\n"
		exit 1
	fi

	if command -v curl > /dev/null 2>&1; then
		download="curl -sLo"
	elif command -v wget > /dev/null 2>&1; then
		download="wget -qO"
	fi

	printf >&2 "\033[1;31m Downloading...\n\033[0m"
	if [ "${next}" -eq 0 ]; then
		release_ver="89luca89/distrobox/archive/refs/tags/${version}.tar.gz"
		release_name=$(basename "${release_ver}")
	else
		release_ver="89luca89/distrobox/archive/refs/heads/main.tar.gz"
		release_name="main"
	fi
	# go in tmp
	tmp_dir="$(mktemp -d)"
	cd "${tmp_dir}"
	# download our target
	${download} "${release_name}" "https://github.com/${release_ver}"
	# uncompress
	printf >&2 "\033[1;31m Unpacking...\n\033[0m"
	if [ "${verbose}" -ne 0 ]; then
		tar xvf "${release_name}"
	else
		tar xf "${release_name}"
	fi
	# deploy our files
	for file in "distrobox-$(echo "${release_name}" | sed 's/.tar.gz//g')"/distrobox*; do
		if ! install -D -m 0755 -t "${dest_path}" "${file}"; then
			printf >&2 "Do you have permission to write to %s?\n" "${dest_path}"
			exit 1
		fi
	done
	if [ -e "distrobox-$(echo "${release_name}" | sed 's/.tar.gz//g')/man/" ]; then
		for file in "distrobox-$(echo "${release_name}" | sed 's/.tar.gz//g')"/man/man1/*; do
			install -D -m 0644 -t "${man_dest_path}" "${file}"
		done
	fi
	if [ -e "distrobox-$(echo "${release_name}" | sed 's/.tar.gz//g')/completions/" ]; then
		for file in "distrobox-$(echo "${release_name}" | sed 's/.tar.gz//g')"/completions/*; do
			install -D -m 0644 -t "${completion_dest_path}" "${file}"
		done
	fi
	if [ -e "distrobox-$(echo "${release_name}" | sed 's/.tar.gz//g')"/terminal-distrobox-icon.png ]; then
		install -D -m 0644 -t "${icon_dest_path}" \
			"distrobox-$(echo "${release_name}" | sed 's/.tar.gz//g')"/terminal-distrobox-icon.png
	fi

fi

[ ! -w "${dest_path}" ] && printf >&2 "Cannot write into %s, permission denied.\n" "${dest_path}" && exit 1
[ ! -w "${man_dest_path}" ] && printf >&2 "Cannot write into %s, permission denied.\n" "${man_dest_path}" && exit 1

printf >&2 "\033[1;31m Successfully installed to %s.\n\033[0m" "${dest_path}"
printf >&2 "\033[1;31m Be sure that %s is in your \$PATH environment variable for it to work.\n\033[0m" "${dest_path}"
EOF
make install PREFIX=usr

make install-manpages PREFIX=usr
