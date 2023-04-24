#!/bin/bash

PKGVERSION=2022.83
PKGNAME="dropbear"
SOURCEFILE="dropbear-${PKGVERSION}.tar.bz2"
URL="https://matt.ucc.asn.au/dropbear/releases/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS} --disable-syslog 
	make -j${NPROC} PROGRAMS="dropbear dbclient dropbearkey scp"
	make install DESTDIR=${DESTDIR} PROGRAMS="dropbear dbclient dropbearkey scp"
}
