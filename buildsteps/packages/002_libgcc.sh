#!/bin/bash

PKGVERSION=10.2.0
PKGNAME="libgcc"

build() {
	mkdir -p ${DESTDIR}/lib64/
	cp -dvp /clfs/cross-tools/aarch64-linux-gnu/lib64/libgcc_s.so* ${DESTDIR}/lib64
	cp -dvp /clfs/cross-tools/aarch64-linux-gnu/lib64/libstdc++.so.6 ${DESTDIR}/lib64
	cp -dvp /clfs/cross-tools/aarch64-linux-gnu/lib64/libstdc++.so.6.0.28 ${DESTDIR}/lib64
	cp -dvp /clfs/cross-tools/aarch64-linux-gnu/lib64/libstdc++.so ${DESTDIR}/lib64
}
