#!/bin/bash

PKGVERSION="5.9.5"
PKGNAME="linux-kernel"
SOURCEFILE="linux-${PKGVERSION}.tar.xz"
URL="https://cdn.kernel.org/pub/linux/kernel/v5.x"
DONTSTRIP=1

build() {
	for i in $(ls ../../patches/kernel); do
		patch -p1 < ../../patches/kernel/${i}
	done
	cp ../../configs/kernel.${ARCH}.conf .config
	make oldconfig
	make -j16 Image
	make -j16 modules dtbs
	make modules_install INSTALL_MOD_PATH=${DESTDIR}
	make dtbs_install INSTALL_DTBS_PATH=${DESTDIR}/boot/dtbs/linux-${PKGVERSION}
	mkdir -p ${DESTDIR}/boot
	cp arch/${ARCH}/boot/Image ${DESTDIR}/boot/
}
