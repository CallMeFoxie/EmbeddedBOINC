#!/bin/bash

PKGVERSION=7.84.0
PKGNAME="curl"
SOURCEFILE="curl-${PKGVERSION}.tar.xz"
suburl=$(echo $PKGVERSION | sed 's/\./_/g')
URL="https://github.com/curl/curl/releases/download/curl-${suburl}/"

build() {
	for i in $(ls ../../patches/curl); do
                echo "Patching $i"
                patch -p1 < ../../patches/curl/${i}
        done
	./configure ${DEFAULT_CONFIGURE_FLAGS} --with-ssl --disable-ipv6 --disable-unix-sockets --disable-verbose --without-libidn --with-zlib  --with-ca-bundle=/etc/ssl/ca-bundle.crt
	make -j${NPROC}
	make install DESTDIR=${DESTDIR}
}
