#!/bin/bash

PKGVERSION=7.16.11
PKGNAME="boinc-client"
SOURCEFILE="${PKGVERSION}.tar.gz"
URL="https://github.com/BOINC/boinc/archive/client_release/7.16/"
BUILDDEPS=""

build() {
	./_autosetup
	./configure ${DEFAULT_CONFIGURE_FLAGS} --disable-server --disable-fcgi --disable-manager
	make -j16
	make install DESTDIR=${DESTDIR}
}

unpack() {
	mv "build/boinc-client_release-7.16-${PKGVERSION}" "build/${PKGVERSION}"
}
