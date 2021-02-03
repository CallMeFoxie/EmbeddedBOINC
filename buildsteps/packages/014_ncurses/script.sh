#!/bin/bash

PKGVERSION=6.2
PKGNAME="ncurses"
SOURCEFILE="ncurses-${PKGVERSION}.tar.gz"
URL="https://ftp.gnu.org/pub/gnu/ncurses/"

build() {
	./configure ${DEFAULT_CONFIGURE_FLAGS} --without-progs --with-termlib --enable-widec --with-shared
	make -j16
	make install DESTDIR=${DESTDIR}
	make distclean
	./configure ${DEFAULT_CONFIGURE_FLAGS} --without-progs --with-termlib --with-shared
	make -j16
	make install DESTDIR=${DESTDIR}

	echo "Removing all terminfos except PuTTy and linux..."
	find ${DESTDIR}/usr/share/terminfo/ ! -name "*putty*" -a ! -name "*linux*" -delete || :
}
