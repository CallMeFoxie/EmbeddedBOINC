#!/bin/bash

PKGVERSION=2.9.2.0
PKGNAME="s6"
SOURCEFILE="s6-${PKGVERSION}.tar.gz"
URL="https://skarnet.org/software/s6/"

build() {
	patch -p1 < ../../patches/s6-linux.patch
	./configure --prefix=/usr --target=aarch64-linux-gnu --with-sysdeps=${TARGETFS}/usr/lib/skalibs/sysdeps --disable-execline
	make -j16
	make install DESTDIR=${DESTDIR}
}
