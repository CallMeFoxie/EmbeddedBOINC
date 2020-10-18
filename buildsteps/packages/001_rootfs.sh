#!/bin/bash

PKGVERSION="1.0"
PKGNAME="rootfs"

build() {
	echo "Creating from empty"
	cd $DESTDIR
	cp -rvpd ../rootfiles/* .
}

package() {
	tar cvp . | xz > "${1}-bin.tar.xz"
}
