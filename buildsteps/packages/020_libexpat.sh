#!/bin/bash

PKGVERSION=2.2.10
PKGNAME="expat"
SOURCEFILE="expat-${PKGVERSION}.tar.xz"
URL="https://github.com/libexpat/libexpat/releases/download/R_2_2_10/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS} --without-examples --without-tests
	make -j16
	make install DESTDIR=${DESTDIR}
}
