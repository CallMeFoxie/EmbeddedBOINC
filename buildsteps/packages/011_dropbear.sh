#!/bin/bash

PKGVERSION=2020.80
PKGNAME="dropbear"
SOURCEFILE="dropbear-${PKGVERSION}.tar.bz2"
URL="https://matt.ucc.asn.au/dropbear/releases/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS} --disable-syslog 
	make -j16
	make install DESTDIR=${DESTDIR}
}
