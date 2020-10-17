#!/bin/bash

PKGVERSION=7.16.11
PKGNAME="boinc-client"
SOURCEFILE="${PKGVERSION}.tar.gz"
URL="https://github.com/BOINC/boinc/archive/client_release/7.16/"
BUILDDEPS=""

build() {
	./_autosetup
	./configure --prefix=/usr --host=aarch64-linux-gnu --disable-server --disable-fcgi --disable-manager --sysconfdir=/etc --localstatedir=/var 
	make -j16
	make install DESTDIR=${DESTDIR}
}

unpack() {
	mv "build/boinc-client_release-7.16-${PKGVERSION}" "build/${PKGVERSION}"
}
