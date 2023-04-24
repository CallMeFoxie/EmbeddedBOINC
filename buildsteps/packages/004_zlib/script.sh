#!/bin/bash

PKGVERSION=1.2.13
PKGNAME="zlib"
SOURCEFILE="zlib-${PKGVERSION}.tar.gz"
URL="https://zlib.net/"

build() {
	export CHOST=${CLFS_TARGET}
	export LDSHARED="$CC -shared"
	export CFLAGS="-fPIC"
	export CPPFLAGS="-fPIC"
	CHOST=${CLFS_TARGET} ./configure --prefix=/usr 
	make install DESTDIR=${DESTDIR}
}
