#!/usr/bin/env bash
set -euo pipefail
stream="$1"
release="$2"

# commitmeta url for given FCOS release:
# https://builds.coreos.fedoraproject.org/prod/streams/testing/builds/34.20210518.2.1/x86_64/commitmeta.json'
commitmeta_url="https://builds.coreos.fedoraproject.org/prod/streams/${stream}/builds/${release}/x86_64/commitmeta.json"
# kernel-devel jq url template:
# https://kojipkgs.fedoraproject.org//packages/kernel/5.12.7/300.fc34/x86_64/kernel-devel-5.12.7-300.fc34.x86_64.rpm
rpm_url='https://kojipkgs.fedoraproject.org//packages/kernel/\(.version)/\(.release)/\(.arch)/kernel-devel-\(.version)-\(.release).\(.arch).rpm'

# Get the version from the kernel package located in the
# 'rpmostree.rpmdb.pkglist' field:
#
# [
#   "kernel",
#   "0",
#   "5.11.15",
#   "300.fc34",
#   "x86_64"
# ]
kernelinfo=$(curl "${commitmeta_url}" | \
	jq '."rpmostree.rpmdb.pkglist"[] | select(.[0] == "kernel") | {"version": .[2], "release": .[3], "arch": .[4]} // null')
if [[ -z "$kernelinfo" ]]; then
	echo "error processing commitmeta"
	exit 1
fi
curl -L -o /tmp/kernel-devel.rpm "$(printf '%s\n' "$kernelinfo" | jq -r ". | \"${rpm_url}\"")"
rpm -v -i --oldpackage /tmp/kernel-devel.rpm
rm -f /tmp/kernel-devel.rpm 
