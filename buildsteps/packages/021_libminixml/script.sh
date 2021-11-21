#!/bin/bash

PKGVERSION=3.2
PKGNAME="minixml"
SOURCEFILE="v${PKGVERSION}.tar.gz"
URL="https://github.com/michaelrsweet/mxml/archive/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS}
	make -j${NPROC}
	make install DSTROOT=${DESTDIR}
}

unpack() {
	mv build/mxml-3.2 build/v3.2
}
