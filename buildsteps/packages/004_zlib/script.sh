#!/bin/bash

PKGVERSION=1.2.11
PKGNAME="zlib"
SOURCEFILE="zlib-${PKGVERSION}.tar.gz"
URL="https://zlib.net/"

build() {
	./configure --prefix=/usr 
	make install DESTDIR=${DESTDIR}
}
