#!/bin/bash

PKGVERSION=5.3.2.0
PKGNAME="gridcoin"
SOURCEFILE="${PKGVERSION}.tar.gz"
URL="https://github.com/gridcoin-community/Gridcoin-Research/archive/refs/tags/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS} --with-gui=no
	make -j16
	make install DESTDIR=${DESTDIR}
}
