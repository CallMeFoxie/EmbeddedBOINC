#!/bin/bash

PKGVERSION="1_1_1l"
PKGNAME="openssl"
SOURCEFILE="OpenSSL_${PKGVERSION}.tar.gz"
URL="https://github.com/openssl/openssl/archive/"

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
	make -j16
	make install DESTDIR=${DESTDIR}
}

unpack() {
	mv build/openssl-OpenSSL_${PKGVERSION} build/OpenSSL_${PKGVERSION}
}
