#!/bin/bash

PKGVERSION=7.73.0
PKGNAME="curl"
SOURCEFILE="curl-${PKGVERSION}.tar.xz"
URL="https://github.com/curl/curl/releases/download/curl-7_73_0/"
BUILDDEPS=""

build() {
	./configure --prefix=/usr --host=aarch64-linux-gnu --with-ssl --disable-ipv6 --disable-unix-sockets --disable-verbose --without-libidn --with-zlib
	make -j16
	make install DESTDIR=${DESTDIR}
}
