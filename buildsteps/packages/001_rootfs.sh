#!/bin/bash

PKGVERSION="1.0"
PKGNAME="rootfs"

build() {
	echo "Creating from empty"
}

package() {
	mkdir -p bin sbin lib lib64 usr/{bin,sbin,lib} etc proc sys boot dev home root mnt opt run var/{lib,lock} tmp run
	ln -s tmp var/
	ln -s run var/
	tar cvp . | xz > "${1}-bin.tar.xz"
}
