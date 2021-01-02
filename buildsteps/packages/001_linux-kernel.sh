#!/bin/bash

PKGVERSION="5.10.4"
PKGNAME="linux-kernel"
SOURCEFILE="linux-${PKGVERSION}.tar.xz"
URL="https://cdn.kernel.org/pub/linux/kernel/v5.x"
DONTSTRIP=1

build() {
	cp ../../mkimage -v /usr/bin/mkimage
	for i in $(ls ../../patches/kernel); do
		echo "Patching $i"
		patch -p1 < ../../patches/kernel/${i}
	done
	cp ../../configs/kernel.${ARCH}.conf .config
	make oldconfig
	outfile="Image"
	if [ x"${ARCH}" = "xarm" ]; then
		outfile="zImage"
	fi
	make -j16 ${outfile}
	make -j16 modules dtbs
	mkdir -p ${DESTDIR}/boot
	if [ x"${ARCH}" = "xarm" ]; then
		make LOADADDR=0x00208000 uImage -j16
		cp arch/${ARCH}/boot/uImage ${DESTDIR}/boot/ulinux-odroidc1
	fi
	make modules_install INSTALL_MOD_PATH=${DESTDIR}
	make dtbs_install INSTALL_DTBS_PATH=${DESTDIR}/boot/dtbs/linux-${PKGVERSION}
	cp arch/${ARCH}/boot/${outfile} ${DESTDIR}/boot/
}
