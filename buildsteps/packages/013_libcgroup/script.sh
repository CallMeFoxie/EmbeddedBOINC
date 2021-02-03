#!/bin/bash

PKGVERSION=0.41
PKGNAME="libcgroup"
SOURCEFILE="libcgroup-${PKGVERSION}.tar.bz2"
URL="https://downloads.sourceforge.net/project/libcg/libcgroup/v0.41/libcgroup-0.41.tar.bz2"

build() {
	ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes ./configure ${DEFAULT_CONFIGURE_FLAGS} --disable-pam --disable-daemon
	make -j16
	make install DESTDIR=${DESTDIR}
}
