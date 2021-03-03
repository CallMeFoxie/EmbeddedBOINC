#!/bin/bash

set -eu

build_device() {
	DEVICE=$1
	CONFIG=$2

	source "devices/${DEVICE}.cfg"
	source "${CONFIG}"
	source "platforms/${PLATFORM}.cfg"

	kernel_version=$(tar tvpf out/linux-kernel-*-bin_*.${BASEARCH}.tar.xz  | grep "dtbs" | awk '{print $6}' | cut -d'/' -f4 | cut -d'-' -f2 | sort | tail -n 1)

	if [ ! -z "${MACS+x}" ]; then
		for i in ${MACS}; do
			mac=$(echo "01-$i" | cut -d';' -f1 | tr '[:upper:]' '[:lower:]' | sed 's/:/-/g')
			uebohostname=$(echo $i | cut -d';' -f2)
			append=""
			if [ x"${uebohostname}" != "x" ]; then
				append="${append} uebo.hostname=${uebohostname}"
			fi
			if [ ! -z "${BOINC_NFS+x}" ]; then
				append="${append} uebo.nfsdir=${BOINC_NFS}/${uebohostname}"
			fi
			if [ ! -z "${UEBO_CONSUL+x}" ]; then
				append="${append} uebo.consul=${UEBO_CONSUL}"
			fi
			append="${append} uebo.boinc.password=${BOINC_PASSWORD} uebo.boinc.remote_hosts=${BOINC_REMOTE_HOSTS}"

			cat <<EOF >tftproot/pxelinux.cfg/${mac}
timeout 50
default d-i
	label d-i
	linux /boot/${KERNEL}-${BASEARCH}-${kernel_version}
	initrd /initramfs-${PLATFORM}-${kernel_version}.zst
	fdt /boot/dtbs/linux-${kernel_version}/${DTB}.dtb
	append ${append}
EOF
		done
	fi
}

config=${1:-".config"}

for device in $(ls devices/*.cfg); do
	xdevice=$(echo $device | rev | cut -d'.' -f2- | rev | cut -d'/' -f2)
	build_device $xdevice $config
done
