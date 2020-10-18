#!/bin/bash

PKGVERSION=2.1.2
PKGNAME="runit"
SOURCEFILE="runit-${PKGVERSION}.tar.gz"
URL="http://smarden.org/runit/"

build() {
	cp src/reboot_system.h2 src/reboot_system.h
	cp src/direntry.h2 src/direntry.h
	cp src/hasmkffo.h2 src/hasmkffo.h
	cp src/hasflock.h2 src/hasflock.h
	cp src/hassgact.h2 src/hassgact.h
	cp src/hassgprm.h2 src/hassgprm.h
	cp src/hasshsgr.h2 src/hasshsgr.h
	cp src/haswaitp.h2 src/haswaitp.h
	cp src/iopause.h2 src/iopause.h
	cp src/select.h2 src/select.h
	cp src/uint64.h2 src/uint64.h
	echo "aarch64-linux-gnu-gcc -O2 -Wall --sysroot=/" > src/conf-cc
	echo "aarch64-linux-gnu-gcc -s --sysroot=/" > src/conf-ld
	sed -i src/Makefile -e "237d"
	cd src
	make
	make runsvstat runsvctrl svwaitup svwaitdown
	mkdir -p ${DESTDIR}/sbin
	for destfile in $(cat Makefile | grep -i "\.\/load" | egrep -v "try|chkshsgr" | awk '{print $2}'); do
		cp -v $destfile ${DESTDIR}/sbin/
	done
}

unpack() {
	mv build/admin/* build/
}
