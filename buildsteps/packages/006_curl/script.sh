#!/bin/bash

PKGVERSION=7.79.1
PKGNAME="curl"
SOURCEFILE="curl-${PKGVERSION}.tar.xz"
suburl=$(echo $PKGVERSION | sed 's/\./_/g')
URL="https://github.com/curl/curl/releases/download/curl-${suburl}/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS} --with-ssl --disable-ipv6 --disable-unix-sockets --disable-verbose --without-libidn --with-zlib  --with-ca-bundle=/etc/ssl/ca-bundle.crt
	make -j16
	make install DESTDIR=${DESTDIR}
}
