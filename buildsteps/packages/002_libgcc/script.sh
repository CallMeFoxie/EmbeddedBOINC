#!/bin/bash

PKGVERSION=11.1.0
PKGNAME="libgcc"

build() {
	mkdir -p ${DESTDIR}/lib${IS64}/
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libgcc_s.so* ${DESTDIR}/lib${IS64}
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libstdc++.so.6 ${DESTDIR}/lib${IS64}
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libstdc++.so.6.0.29 ${DESTDIR}/lib${IS64}
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libstdc++.so ${DESTDIR}/lib${IS64}
	cp -dvp /clfs/cross-tools/${CLFS_TARGET}/lib${IS64}/libgomp.so* ${DESTDIR}/lib${IS64}
}
