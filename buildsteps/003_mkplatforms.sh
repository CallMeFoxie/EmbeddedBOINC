#!/bin/bash

set -eu

FAKEROOT=$(which fakeroot)
MKPASSWD=$(which mkpasswd)
MKIMAGE=$(which mkimage)

if [ x"${FAKEROOT}" = "x" ]; then
	echo "missing fakeroot!"
	exit 1
fi

if [ x"${MKPASSWD}" = "x" ]; then
	echo "missing mkpasswd!"
	exit 1
fi

if [ x"${MKIMAGE}" = "x" ]; then
	echo "missing mkimage!"
	exit 1
fi

build_platform() {
	PLATFORM=$1
	CONFIG=$2

	if [ ! -f "${CONFIG}" ]; then
		echo "Missing build config! You can check example in sample.config. Copy it to .config and do your edits!"
		exit 1
	fi

	source platforms/${PLATFORM}.cfg
	source "${CONFIG}"

	BOINC_NFS=${BOINC_NFS:-""}
	[ -z "${BOINC_PASSWORD}" ] && echo "Missing BOINC_PASSWORD!" && exit 1
	[ -z "${BOINC_REMOTE_HOSTS}" ] && echo "Missing BOINC_REMOTE_HOSTS!" && exit 1
	UEBO_CONSUL=${UEBO_CONSUL:-""}
	SSHKEY=${SSHKEY:-""}

	kernel_version=$(tar tvpf out/linux-kernel-*-bin_*.${BASEARCH}.tar.xz  | grep "dtbs" | awk '{print $6}' | cut -d'/' -f4 | cut -d'-' -f2 | sort | tail -n 1)

	rm -rf rootimage initramfs*
	mkdir -p rootimage

	cp -rpd rootfiles/* rootimage/
	mkdir -p rootimage/{proc,sys,run,tmp,dev}

	cat <<EOF >> rootimage/etc/motd
  ______           _              _     _          _   ____   ____ _____ _   _  _____ 
 |  ____|         | |            | |   | |        | | |  _ \\ / __ |_   _| \\ | |/ ____|
 | |__   _ __ ___ | |__   ___  __| | __| | ___  __| | | |_) | |  | || | |  \\| | |     
 |  __| | '_ \` _ \\| '_ \\ / _ \\/ _\` |/ _\` |/ _ \\/ _\` | |  _ <| |  | || | | . \` | |     
 | |____| | | | | | |_) |  __| (_| | (_| |  __| (_| | | |_) | |__| _| |_| |\\  | |____ 
 |______|_| |_| |_|_.__/ \\___|\\__,_|\\__,_|\\___|\\__,_| |____/ \\____|_____|_| \\_|\\_____|
                                                                                      
                                                                                      
EOF

	cat <<EOF >> rootimage/etc/os-release
NAME=EmbeddedBOINC
PRETTY_NAME=EmbeddedBOINC
VERSION=$(git describe || echo "master")
ID=uebo
TFORM="${PLATFORM}"
VARIANT=${BASEARCH}+${EXTRAARCHS}
EOF

	echo "=== welcome to Embedded BOINC shell ===" >> rootimage/etc/motd

	for i in ${BASEPKGS}; do
		tar xvpf out/${i}*-bin_*.${BASEARCH}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-bin_*.${BASEARCH}.tar.xz) >> rootimage/var/pkgs.txt || :
		tar xvpf out/${i}*-lib_*.${BASEARCH}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-lib_*.${BASEARCH}.tar.xz) >> rootimage/var/pkgs.txt || :
	done

	echo "> arch support: ${BASEARCH} ${EXTRAARCHS}" >> rootimage/etc/motd
	for arch in ${EXTRAARCHS}; do
		for i in glibc libgcc; do
			tar xvpf out/${i}*-bin_*.${arch}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-bin_*.${arch}.tar.xz) >> rootimage/var/pkgs.txt || :
			tar xvpf out/${i}*-lib_*.${arch}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-lib_*.${arch}.tar.xz) >> rootimage/var/pkgs.txt || :
		done
	done

	echo "> build date: $(date)" >> rootimage/etc/motd

	PASSWORD=$(echo -n $PASSWORD | mkpasswd -m sha-512 -s)

	echo "Adding user ${USERNAME}"
	echo "${USERNAME}:x:0:0:${USERNAME},,,:/root:/bin/sh" >> rootimage/etc/passwd
	echo "${USERNAME}:${PASSWORD}:18288:0:99999:7:::" >> rootimage/etc/shadow

	[ ! -z "${SSHKEY+x}" ] && echo "Adding SSH key from ${SSHKEY}" && cp "${SSHKEY}" rootimage/root/.ssh/authorized_keys

	for KERNEL in ${KERNELS}; do
		tar xvpf out/linux-kernel*-bin_*.${BASEARCH}.tar.xz -C tftproot "./boot/${KERNEL}"
		mv tftproot/boot/${KERNEL} tftproot/boot/${KERNEL}-${BASEARCH}-${kernel_version}
	done

	tar xvpf out/linux-kernel*-bin_*.${BASEARCH}.tar.xz -C tftproot --wildcards --no-anchored "*.dtb"


	# kernel needs only lib package, bin has to go into tftp root
	tar xvpf out/linux-kernel*-lib_*.${BASEARCH}.tar.xz -C rootimage/
	(
		cd rootimage
		find . | sort | uniq | fakeroot cpio -H newc -o > ../initramfs-${PLATFORM}-${kernel_version}
	)
	zstd initramfs-${PLATFORM}-${kernel_version}
	rm initramfs-${PLATFORM}-${kernel_version}

	echo "New initramfs for testing is ready!"
	ls -lh initramfs-${PLATFORM}-${kernel_version}.zst

	if [ ! -z "${UINITRD+x}" ]; then
		mkimage -A arm -T ramdisk -C none -n uInitrd -d initramfs-${PLATFORM}-${kernel_version}.zst tftproot/uInitramfs-${PLATFORM}-${kernel_version}
	fi

	mv initramfs-${PLATFORM}-${kernel_version}.zst tftproot/
}

rm -rf tfproot/

config=${1:-".config"}

for platform in $(ls platforms/*.cfg); do
	platname=$(echo $platform | rev | cut -d'.' -f2- | rev | cut -d'/' -f2)
	build_platform $platname $config
done
