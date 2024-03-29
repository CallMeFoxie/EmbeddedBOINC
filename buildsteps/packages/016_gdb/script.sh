#!/bin/bash

PKGVERSION=10.1
PKGNAME="gdb"
SOURCEFILE="gdb-${PKGVERSION}.tar.xz"
URL="ftp://sourceware.org/pub/gdb/releases"

build() {
	cd ..
	rm -rf gdb-build || :
	mkdir gdb-build
	cd gdb-build
	../gdb-${PKGVERSION}/configure ${DEFAULT_CONFIGURE_FLAGS}
	make -j${NPROC}
	make install DESTDIR=${DESTDIR}
}
