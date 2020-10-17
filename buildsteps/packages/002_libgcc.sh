#!/bin/bash

PKGVERSION=10.2.0
PKGNAME="libgcc"

build() {
	mkdir -p ${DESTDIR}/lib64/
	cp -dvp /clfs/cross-tools/aarch64-linux-gnu/lib64/libgcc_s.so* ${DESTDIR}/lib64
}
