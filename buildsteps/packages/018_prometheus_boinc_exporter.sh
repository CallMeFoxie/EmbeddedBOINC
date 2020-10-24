#!/bin/bash

PKGVERSION=httpversion
PKGNAME="prometheus-boinc-exporter"
SOURCEFILE="${PKGVERSION}.tar.gz"
URL="https://github.com/CallMeFoxie/prometheus-boinc-exporter/archive/"
DONTSTRIP=1

build() {
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" main.go
	mkdir -p ${DESTDIR}/usr/bin/
	cp main ${DESTDIR}/usr/bin/boinc_exporter
}

unpack() {
	mv build/prometheus-boinc-exporter-${PKGVERSION} build/${PKGVERSION}
}
