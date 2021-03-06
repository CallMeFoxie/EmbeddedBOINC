#!/bin/bash

PKGVERSION=1.45.6
PKGNAME="e2fsprogs"
SOURCEFILE="e2fsprogs-${PKGVERSION}.tar.gz"
URL="https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/snapshot"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS} --enable-fsck 
	make -j16
	make install DESTDIR=${DESTDIR}
}
