#!/bin/bash

PKGVERSION=7.75.0
PKGNAME="curl"
SOURCEFILE="curl-${PKGVERSION}.tar.xz"
URL="https://github.com/curl/curl/releases/download/curl-7_75_0/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS} --with-ssl --disable-ipv6 --disable-unix-sockets --disable-verbose --without-libidn --with-zlib  --with-ca-bundle=/etc/ssl/ca-bundle.crt
	make -j16
	make install DESTDIR=${DESTDIR}
}
