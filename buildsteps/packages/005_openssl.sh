#!/bin/bash

PKGVERSION="1_1_1h"
PKGNAME="openssl"
SOURCEFILE="OpenSSL_${PKGVERSION}.tar.gz"
URL="https://github.com/openssl/openssl/archive/"

build() {
	export CROSS_COMPILE=
	./Configure linux-aarch64 --prefix=/usr
	make -j16
	make install DESTDIR=${DESTDIR}
}

unpack() {
	mv build/openssl-OpenSSL_${PKGVERSION} build/OpenSSL_${PKGVERSION}
}
