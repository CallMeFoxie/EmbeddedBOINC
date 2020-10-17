#!/bin/bash

set -eu

export DESTDIR="$(pwd)/destdir"
export STRIP="aarch64-linux-gnu-strip -s"

export TARGETFS="/clfs/targetfs/"
export TARGETDEV="/clfs/targetdev/"

export DEFAULT_CONFIGURE_FLAGS="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --build=${CLFS_HOST} --host=${CLFS_TARGET}"

mkdir -p ${TARGETFS} ${TARGETDEV} build sources out

rm -rf ${TARGETFS}/* ${TARGETDEV}/* build/*

package_default() {
	rm -rf ../tmp
	mkdir -p ../tmp
	# help files
	find . \
		-path "./usr/share/man/*" -o \
		-path "./usr/share/doc/*" \
		>> ../tmp/helpfiles.txt
	# dev files
	find . \
		-path "./usr/include*" -o \
		-path "./usr/lib/pkgconfig*" -o \
		-path "./usr/lib/*.a" -o \
		-path "./usr/lib64/*.a" -o \
		-path "./lib/*.a" -o \
		-path "./lib64/*.a" -o \
		-path "./usr/lib64/*.o" -o \
		-path "./usr/lib/*.la" \
		>> ../tmp/devfiles.txt
	# lib files
	find . \
		-path "./usr/lib/*.so*" -o \
		-path "./lib/*.so*" -o \
		-path "./lib64/*.so*" -o \
		-path "./usr/lib64/*.so*" \
		>> ../tmp/libfiles.txt
	# bin files
	find . \
		-path "./usr/bin/*" -o \
		-path "./bin/*" -o \
		-path "./usr/sbin/*" -o \
		-path "./sbin/*" -o \
		-path "./etc/*" \
		>> ../tmp/binfiles.txt
	
	# strip binaries and libraries
	for xfile in $(cat ../tmp/binfiles.txt ../tmp/libfiles.txt); do
		isstrippable=$(file $xfile | grep "not stripped" || :)
		if [ ! -z "${isstrippable}" ]; then
			echo "> stripping $xfile"
			$STRIP $xfile
		fi
	done

	for i in help dev lib bin; do
		[ "$(cat ../tmp/${i}files.txt | sort | uniq | wc -l)" -ne 0 ] && tar cvT ../tmp/${i}files.txt | xz > "${1}-${i}.tar.xz"
		cat ../tmp/${i}files.txt | xargs rm -rf
	done

	find . -type f >> ../tmp/leftovers.txt
	[ "$(cat ../tmp/leftovers.txt | sort | uniq | wc -l)" -ne 0 ] && tar cvT ../tmp/leftovers.txt | xz > "${1}-leftover.tar.xz" || :
}

for pkgfile in $(ls packages | sort -n); do
	source ./packages/${pkgfile}
	rm -rf tmp/
	echo "==== Working with ${PKGNAME} @ ${PKGVERSION} ===="
	BUILD=1

	if [ -f "out/${PKGNAME}-${PKGVERSION}-bin.tar.xz" -o -f "out/${PKGNAME}-${PKGVERSION}-lib.tar.xz" ]; then
		BUILD=0
	fi

	if [ $BUILD -eq 1 ]; then
		SOURCEFILE=${SOURCEFILE:-""}
		URL=${URL:-""}

		if [ ! -f sources/${SOURCEFILE} -a ! -z "${URL}" ]; then
			echo "==== Fetching ${URL}/${SOURCEFILE} ===="
			wget "${URL}/${SOURCEFILE}" -O sources/${SOURCEFILE}
		fi


		PKGPATH=${PKGPATH:-$(echo ${SOURCEFILE} | sed 's/\.tar.*//')}
		rm -rf build/${PKGPATH} destdir || :
		mkdir -p destdir build

		if [ -f "sources/${SOURCEFILE}" ]; then
			echo "==== Unpacking ${SOURCEFILE} ===="
			tar xpf sources/${SOURCEFILE} -C build/
		fi
		hasunpack=$(type -t unpack || :)
		if [ ! -z "$hasunpack" ]; then
			unpack
		fi

		echo "==== Building ${pkgfile} ===="
		(
			cd build/${PKGPATH}
			build
		)
		echo "=== Packaging ${pkgfile} ==="
		haspackaging=$(type -t package || :)
		if [ -n "$haspackaging" ]; then
			(
				cd destdir
				package "../out/${PKGNAME}-${PKGVERSION}"
			)
		else
			(
				cd destdir
				package_default "../out/${PKGNAME}-${PKGVERSION}"
			)
		fi
	fi
	unset -f unpack
	unset -f package
	unset PKGPATH haspackaging hasunpack

	tar xpf "out/${PKGNAME}-${PKGVERSION}-lib.tar.xz" -C ${TARGETFS} || :
	tar xpf "out/${PKGNAME}-${PKGVERSION}-dev.tar.xz" -C ${TARGETFS} || :
	tar xpf "out/${PKGNAME}-${PKGVERSION}-bin.tar.xz" -C ${TARGETFS} || :
done
