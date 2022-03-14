#!/bin/bash

PKGVERSION=1.0.13
PKGNAME="lldpd"
SOURCEFILE="lldpd-${PKGVERSION}.tar.gz"
URL="https://github.com/lldpd/lldpd/releases/download/${PKGVERSION}/"

build() {
	./autogen.sh
	./configure ${DEFAULT_CONFIGURE_FLAGS}
	make -j${NPROC}
	make install DESTDIR=${DESTDIR}
}
