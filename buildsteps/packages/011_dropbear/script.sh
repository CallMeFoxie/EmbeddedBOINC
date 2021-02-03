#!/bin/bash

PKGVERSION=2020.81
PKGNAME="dropbear"
SOURCEFILE="dropbear-${PKGVERSION}.tar.bz2"
URL="https://matt.ucc.asn.au/dropbear/releases/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS} --disable-syslog 
	make -j16 PROGRAMS="dropbear dbclient dropbearkey scp"
	make install DESTDIR=${DESTDIR} PROGRAMS="dropbear dbclient dropbearkey scp"
}
