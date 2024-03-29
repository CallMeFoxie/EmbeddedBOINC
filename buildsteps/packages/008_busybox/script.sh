#!/bin/bash

PKGVERSION=1.32.1
PKGNAME="busybox"
SOURCEFILE="busybox-${PKGVERSION}.tar.bz2"
URL="https://busybox.net/downloads/"

build() {
	cp ../../configs/busybox.conf .config
	ARCH="arm64" make oldconfig
	make -j${NPROC}
	make install
	mv _install/* ${DESTDIR}
	mkdir -p ${DESTDIR}/etc/udhcpc/
	cp examples/udhcp/simple.script ${DESTDIR}/etc/udhcpc/simple.script
}
