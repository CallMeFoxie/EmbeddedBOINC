#!/bin/bash

PKGVERSION="3.0.5"
PKGNAME="openssl"
SOURCEFILE="openssl-${PKGVERSION}.tar.gz"
URL="https://github.com/openssl/openssl/archive/refs/tags/"

build() {
	export CROSS_COMPILE=
	case $ARCH in
		arm)
			./Configure linux-armv4 --prefix=/usr -march=${CLFS_ARM_ARCH}
			;;
		arm64)
			./Configure linux-aarch64 --prefix=/usr
			;;
		*)
			echo "OpenSSL package: undefined arch ${ARCH}, please add it to the build script and try again."
			exit 1
			;;
	esac
	make -j${NPROC}
	make install DESTDIR=${DESTDIR}
}

unpack() {
	mv build/openssl-openssl-${PKGVERSION} build/openssl-${PKGVERSION}
}
