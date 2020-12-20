#!/bin/bash

PKGVERSION=2.4.103
PKGNAME="libdrm"
SOURCEFILE="libdrm-${PKGVERSION}.tar.xz"
URL="https://dri.freedesktop.org/libdrm/"

build() {
	cp ../../configs/cross-arm64-meson.txt cross_arm64.txt
	unset CC LD CPP
	meson cross-build --cross-file cross_arm64.txt --buildtype release -Dnouveau=false -Dvmwgfx=false  -Dradeon=false -Damdgpu=false -Dfreedreno=false -Dvc4=false --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib${IS64}
	ninja -C cross-build/
	DESTDIR=${DESTDIR} ninja install -C cross-build/
}
