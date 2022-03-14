#!/bin/bash

PKGVERSION=n5.0
PKGNAME="ffmpeg"
SOURCEFILE="${PKGVERSION}.tar.gz"
URL="https://github.com/FFmpeg/FFmpeg/archive/refs/tags"

build() {
	if [ "${ARCH}" = "arm64" ]; then
		confarch="aarch64"
	else
		confarch="arm"
	fi
	./configure --prefix=/usr --libdir=/usr/lib${IS64} --arch=${confarch} --target-os=linux --cross-prefix=${CLFS_TARGET}- --sysroot=/ --disable-all  --enable-small --enable-ffmpeg --enable-network 
	make -j16
}

unpack() {
	mv build/FFmpeg-${PKGVERSION} build/${PKGVERSION}
}
