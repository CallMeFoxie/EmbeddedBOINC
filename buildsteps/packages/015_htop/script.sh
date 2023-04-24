#!/bin/bash

PKGVERSION=3.2.1
PKGNAME="htop"
SOURCEFILE="${PKGVERSION}.tar.gz"
URL="https://github.com/htop-dev/htop/archive/"

build() {
	./autogen.sh
	./configure ${DEFAULT_CONFIGURE_FLAGS} --enable-cgroup --disable-unicode LDFLAGS="-ltinfo"
	make -j${NPROC}
	make install DESTDIR=${DESTDIR}
}

unpack() {
	mv build/htop-${PKGVERSION} build/${PKGVERSION}
}
