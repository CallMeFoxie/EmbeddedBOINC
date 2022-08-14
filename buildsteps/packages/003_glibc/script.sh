#!/bin/bash

PKGVERSION=${glibc_version}
PKGNAME="glibc"
SOURCEFILE="glibc-${PKGVERSION}.tar.xz"
URL="https://ftp.gnu.org/gnu/glibc/"

build() {
	rm -rf ../glibc-build/
	mkdir -p ../glibc-build/
	cd ../glibc-build/
        for i in $(ls ../../patches/glibc); do
                echo "Patching $i"
                patch -d../glibc-${glibc_version}/ -p1 < ../../patches/glibc/${i}
        done
	../glibc-${glibc_version}/configure \
	        CROSS_COMPILE=${CLFS_TARGET}- \
		${DEFAULT_CONFIGURE_FLAGS} \
		--enable-kernel=${MINIMUM_KERNEL}
	make -j${NPROC}
	make install DESTDIR=${DESTDIR}
}
