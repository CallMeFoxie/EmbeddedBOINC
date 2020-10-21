#!/bin/bash

PKGVERSION=9.2
PKGNAME="gdb"
SOURCEFILE="gdb-${PKGVERSION}.tar.xz"
URL="ftp://sourceware.org/pub/gdb/releases"

build() {
	cd ..
	rm -rf gdb-build || :
	mkdir gdb-build
	cd gdb-build
	../gdb-${PKGVERSION}/configure ${DEFAULT_CONFIGURE_FLAGS}
	make -j16
	make install DESTDIR=${DESTDIR}
}
