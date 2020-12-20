#!/bin/bash

PKGVERSION=20.3.1
PKGNAME="mesa"
SOURCEFILE="mesa-${PKGVERSION}.tar.gz"
URL="https://github.com/mesa3d/mesa/archive/"
DONTSTRIP=1

build() {
        cp ../../configs/cross-arm64-meson.txt cross_arm64.txt
        unset CC LD CPP
        meson cross-build --cross-file cross_arm64.txt --buildtype release --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib${IS64}
        ninja -C cross-build/
        DESTDIR=${DESTDIR} ninja install -C cross-build/
}

unpack() {
	mv build/mesa-mesa-${PKGVERSION} build/mesa-${PKGVERSION}
}
