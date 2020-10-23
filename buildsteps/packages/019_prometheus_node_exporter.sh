#!/bin/bash

PKGVERSION=1.0.1
PKGNAME="prometheus-node-exporter"
SOURCEFILE="node_exporter-${PKGVERSION}.linux-arm64.tar.gz"
URL="https://github.com/prometheus/node_exporter/releases/download/v${PKGVERSION}/"
DONTSTRIP=1

build() {
	mkdir -p ${DESTDIR}/usr/bin/
	cp node_exporter ${DESTDIR}/usr/bin/
}

#unpack() {
#	mv build/node_exporter-${PKGVERSION}.linux-arm64 build/${PKGVERSION}
#}
