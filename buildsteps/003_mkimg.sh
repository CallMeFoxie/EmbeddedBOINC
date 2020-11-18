#!/bin/bash

set -eu

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <platform>"
	echo "  platform list:"
	for i in $(ls platform/); do
		i=$(echo $i | cut -d'.' -f1)
		echo "    ${i}"
	done
	exit 1
fi

PLATFORM=$1
BOINC_NFS=""

source platform/${PLATFORM}.cfg

kernel_version=$(tar tvpf out/linux-kernel-*-bin.${BASEARCH}.tar.xz  | grep "dtbs" | awk '{print $6}' | cut -d'/' -f4 | cut -d'-' -f2 | sort | tail -n 1)

rm -rf rootimage initramfs*
mkdir -p rootimage

cp -rpd rootfiles/* rootimage/

cat <<EOF >> rootimage/etc/motd
  ______           _              _     _          _   ____   ____ _____ _   _  _____ 
 |  ____|         | |            | |   | |        | | |  _ \\ / __ |_   _| \\ | |/ ____|
 | |__   _ __ ___ | |__   ___  __| | __| | ___  __| | | |_) | |  | || | |  \\| | |     
 |  __| | '_ \` _ \\| '_ \\ / _ \\/ _\` |/ _\` |/ _ \\/ _\` | |  _ <| |  | || | | . \` | |     
 | |____| | | | | | |_) |  __| (_| | (_| |  __| (_| | | |_) | |__| _| |_| |\\  | |____ 
 |______|_| |_| |_|_.__/ \\___|\\__,_|\\__,_|\\___|\\__,_| |____/ \\____|_____|_| \\_|\\_____|
                                                                                      
                                                                                      
EOF

echo "=== welcome to Embedded BOINC shell ===" >> rootimage/etc/motd

for i in ${BASEPKGS}; do
	tar xvpf out/${i}*-bin.${BASEARCH}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-bin.${BASEARCH}.tar.xz) >> rootimage/var/pkgs.txt || :
	tar xvpf out/${i}*-lib.${BASEARCH}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-lib.${BASEARCH}.tar.xz) >> rootimage/var/pkgs.txt || :
done

echo "> arch support: ${BASEARCH} ${EXTRAARCHS}" >> rootimage/etc/motd
for arch in ${EXTRAARCHS}; do
	for i in glibc libgcc; do
		tar xvpf out/${i}*-bin.${arch}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-bin.${arch}.tar.xz) >> rootimage/var/pkgs.txt || :
		tar xvpf out/${i}*-lib.${arch}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-lib.${arch}.tar.xz) >> rootimage/var/pkgs.txt || :
	done
done

echo "> build date: $(date)" >> rootimage/etc/motd

rm -rf tftproot
mkdir -p tftproot/pxelinux.cfg/
tar xvpf out/linux-kernel*-bin.${BASEARCH}.tar.xz -C tftproot "./boot/${KERNEL}"
mv tftproot/boot/${KERNEL} tftproot/boot/${KERNEL}-${BASEARCH}-${kernel_version}

tar xvpf out/linux-kernel*-bin.${BASEARCH}.tar.xz -C tftproot --wildcards --no-anchored "*.dtb"


# kernel needs only lib package, bin has to go into tftp root
tar xvpf out/linux-kernel*-lib.${BASEARCH}.tar.xz -C rootimage/
(
	cd rootimage
	find . | fakeroot cpio -H newc -o > ../initramfs-${BASEARCH}-${kernel_version}
)
zstd initramfs-${BASEARCH}-${kernel_version}
rm initramfs-${BASEARCH}-${kernel_version}

echo "New initramfs for testing is ready!"
ls -lh initramfs-${BASEARCH}-${kernel_version}.zst

if [ ! -z "${UINITRD+x}" ]; then
	mkimage -A arm -T ramdisk -C none -n uInitrd -d initramfs-${BASEARCH}-${kernel_version}.zst tftproot/uInitramfs-${BASEARCH}-${kernel_version}
fi

mv initramfs-${BASEARCH}-${kernel_version}.zst tftproot/
cat <<EOF >>tftproot/pxelinux.cfg/${PLATFORM}
timeout 50
default d-i
        label d-i
        linux /boot/${KERNEL}-${BASEARCH}-${kernel_version}
        initrd /initramfs-${BASEARCH}-${kernel_version}.zst
	fdt /boot/dtbs/linux-${kernel_version}/${DTB}.dtb
EOF

if [ ! -z "${MACS}" ]; then
	for i in ${MACS}; do
		mac=$(echo "01-$i" | cut -d';' -f1 | tr '[:upper:]' '[:lower:]' | sed 's/:/-/g')
		uebohostname=$(echo $i | cut -d';' -f2)
		append=""
		if [ x"${uebohostname}" != "x" ]; then
			append="${append} uebo.hostname=${uebohostname}"
		fi
		if [ ! -z "${BOINC_NFS}" ]; then
			append="${append} uebo.nfsdir=${BOINC_NFS}/${uebohostname} uebo.boinc.password=test uebo.boinc.remote_hosts=192.168.88.226,10.0.2.1,127.0.0.1"
		fi
		cat <<EOF >tftproot/pxelinux.cfg/${mac}
timeout 50
default d-i
	label d-i
	linux /boot/${KERNEL}-${BASEARCH}-${kernel_version}
	initrd /initramfs-${BASEARCH}-${kernel_version}.zst
	fdt /boot/dtbs/linux-${kernel_version}/${DTB}.dtb
	append ${append}
EOF
	done
fi
