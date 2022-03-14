#!/bin/bash

PKGVERSION=5.3.28
PKGNAME="libdb"
SOURCEFILE="v${PKGVERSION}.tar.gz"
URL="https://github.com/berkeleydb/libdb/archive/refs/tags/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS}
	make -j16
	make install DESTDIR=${DESTDIR}
}
