#!/bin/bash

PKGVERSION=3.0.5
PKGNAME="htop"
SOURCEFILE="${PKGVERSION}.tar.gz"
URL="https://github.com/htop-dev/htop/archive/"

build() {
	./autogen.sh
	./configure ${DEFAULT_CONFIGURE_FLAGS} --enable-cgroup --disable-unicode LDFLAGS="-ltinfo"
	make -j16
	make install DESTDIR=${DESTDIR}
}

unpack() {
	mv build/htop-${PKGVERSION} build/${PKGVERSION}
}
