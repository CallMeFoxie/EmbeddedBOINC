#!/bin/bash

PKGVERSION=1.3.1
PKGNAME="prometheus-node-exporter"
SOURCEFILE="v${PKGVERSION}.tar.gz"
URL="https://github.com/prometheus/node_exporter/archive/"
DONTSTRIP=1

build() {
	CGO_ENABLED=0 go build -ldflags "-s -w"
	mkdir -p ${DESTDIR}/usr/bin/
	cp node_exporter ${DESTDIR}/usr/bin/
}

unpack() {
	mv build/node_exporter-${PKGVERSION} build/v${PKGVERSION}
}
