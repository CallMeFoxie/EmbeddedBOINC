#!/bin/bash

PKGVERSION=0.42.2
PKGNAME="libcgroup"
SOURCEFILE="libcgroup-${PKGVERSION}.tar.bz2"
URL="https://github.com/libcgroup/libcgroup/releases/download/v${PKGVERSION}"

build() {
	ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes ./configure ${DEFAULT_CONFIGURE_FLAGS} --disable-pam --disable-daemon
	make -j${NPROC}
	make install DESTDIR=${DESTDIR}
}
