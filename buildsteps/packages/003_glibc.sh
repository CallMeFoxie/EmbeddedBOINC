#!/bin/bash

PKGVERSION=2.32
PKGNAME="glibc"
SOURCEFILE="glibc-${PKGVERSION}.tar.xz"
URL="https://ftp.gnu.org/gnu/glibc/"

build() {
	rm -rf ../glibc-build/
	mkdir -p ../glibc-build/
	cd ../glibc-build/
	../glibc-${glibc_version}/configure \
	        CROSS_COMPILE=${CLFS_TARGET}- \
	        --prefix=/ \
        	--build=${CLFS_HOST} \
	        --host=${CLFS_TARGET}
	make -j16
	make install DESTDIR=${DESTDIR}
}
