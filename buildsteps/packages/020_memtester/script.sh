#!/bin/bash

PKGVERSION=4.5.0
PKGNAME="memtester"
SOURCEFILE="memtester-${PKGVERSION}.tar.gz"
URL="http://pyropus.ca/software/memtester/old-versions/"

build() {
	echo "${CLFS_TARGET}-gcc -s --sysroot=/" > conf-ld
	echo "${CLFS_TARGET}-gcc -O2 -DPOSIX -D_POSIX_C_SOURCE=200809L -D_FILE_OFFSET_BITS=64 -DTEST_NARROW_WRITES -c" > conf-cc
	make
	mkdir -p ${DESTDIR}/usr/bin/
	cp memtester ${DESTDIR}/usr/bin/
}
