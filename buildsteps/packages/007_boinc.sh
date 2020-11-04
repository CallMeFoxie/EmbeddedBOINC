#!/bin/bash

PKGVERSION=7.16.11
PKGNAME="boinc-client"
SOURCEFILE="${PKGVERSION}.tar.gz"
URL="https://github.com/BOINC/boinc/archive/client_release/7.16/"

build() {
	patch -p1 < ../../patches/boinc/fix-hardfp-arm2.patch
	patch -p1 < ../../patches/boinc/arm64-arm-alt-platform.patch
	./_autosetup
	./configure ${DEFAULT_CONFIGURE_FLAGS} --disable-server --disable-fcgi --disable-manager
	make -j16
	make install DESTDIR=${DESTDIR}
	mkdir -p ${DESTDIR}/etc/ssl/ ${DESTDIR}/etc/boinc-client/
	cp curl/ca-bundle.crt ${DESTDIR}/etc/ssl/ca-bundle.crt
	cp win_build/installerv2/redist/all_projects_list.xml ${DESTDIR}/etc/boinc-client/all_projects_list.xml
	rm -rf ${DESTDIR}/etc/init.d/ ${DESTDIR}/etc/default
}

unpack() {
	mv "build/boinc-client_release-7.16-${PKGVERSION}" "build/${PKGVERSION}"
}
