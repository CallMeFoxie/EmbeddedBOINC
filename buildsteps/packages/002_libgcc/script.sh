#!/bin/bash

PKGVERSION=10.2.0
PKGNAME="libgcc"

build() {
	mkdir -p ${DESTDIR}/lib${IS64}/
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libgcc_s.so* ${DESTDIR}/lib${IS64}
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libstdc++.so.6 ${DESTDIR}/lib${IS64}
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libstdc++.so.6.0.28 ${DESTDIR}/lib${IS64}
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libstdc++.so ${DESTDIR}/lib${IS64}
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libgomp.so* ${DESTDIR}/lib${IS64}
}
