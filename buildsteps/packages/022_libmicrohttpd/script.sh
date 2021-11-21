#!/bin/bash

PKGVERSION=0.9.72
PKGNAME="libmicrohttpd"
SOURCEFILE="libmicrohttpd-${PKGVERSION}.tar.gz"
URL="https://ftp.gnu.org/gnu/libmicrohttpd/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS}
	make -j${NPROC}
	make install DESTDIR=${DESTDIR}
}
