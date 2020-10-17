#!/bin/bash

PKGVERSION=2.9.3.0
PKGNAME="skalibs"
SOURCEFILE="skalibs-${PKGVERSION}.tar.gz"
URL="https://skarnet.org/software/skalibs/"

build() {
	./configure --prefix=/usr --target=aarch64-linux-gnu  --with-sysdep-devurandom=yes
	make -j16
	make install DESTDIR=${DESTDIR}
}
