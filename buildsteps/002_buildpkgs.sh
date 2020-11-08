#!/bin/bash

set -eu

export DESTDIR="$(pwd)/destdir"
export STRIP="${CLFS_TARGET}-strip -s"

export TARGETFS="/clfs/targetfs/"
export TARGETDEV="/clfs/targetdev/"

export DEFAULT_CONFIGURE_FLAGS="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib${IS64} --build=${CLFS_HOST} --host=${CLFS_TARGET}"

export CFLAGS="-O2 -pipe"
export CPPFLAGS="-O2 -pipe"
export CXXFLAGS="-O2 -pipe"

mkdir -p ${TARGETFS} ${TARGETDEV} build sources out

rm -rf ${TARGETFS}/* ${TARGETDEV}/* build/*

package_default() {
	rm -rf ../tmp
	mkdir -p ../tmp
	# help files
	find . \
		-path "./usr/share/man/*" -o \
		-path "./usr/share/doc/*" \
		| sort | uniq > ../tmp/helpfiles.txt
	# dev files
	find . \
		-path "./usr/include*" -o \
		-path "./usr/lib/pkgconfig*" -o \
		-path "./usr/lib/*.a" -o \
		-path "./usr/lib64/*.a" -o \
		-path "./lib/*.a" -o \
		-path "./lib64/*.a" -o \
		-path "./usr/lib64/*.o" -o \
		-path "./usr/lib/*.la" -o \
		-path "./usr/lib/*/sysdeps/*" -o \
		-path "./usr/share/aclocal/*" \
		| sort | uniq > ../tmp/devfiles.txt
	# lib files
	find . \
		-path "./usr/lib/*.so*" -o \
		-path "./lib/*.so*" -o \
		-path "./lib64/*.so*" -o \
		-path "./usr/lib64/*.so*" -o \
		-path "./lib/modules/*" \
		| sort | uniq > ../tmp/libfiles.txt
	# bin files
	find . \
		-path "./usr/bin/*" -o \
		-path "./bin/*" -o \
		-path "./usr/sbin/*" -o \
		-path "./sbin/*" -o \
		-path "./etc/*" -o \
		-path "./usr/libexec/*" -o \
		-path "./usr/share/terminfo/*" -o \
		-path "./usr/share/tabset/*" -o \
		-path "./usr/share/gdb/*" -o \
		-path "./boot/*" \
		| sort | uniq > ../tmp/binfiles.txt
	
	# strip binaries and libraries
	DONTSTRIP=${DONTSTRIP:-""}
	if [ x"${DONTSTRIP}" = "x" ]; then
		for xfile in $(cat ../tmp/binfiles.txt ../tmp/libfiles.txt); do
			isstrippable=$(file $xfile | grep "not stripped" || :)
			if [ ! -z "${isstrippable}" ]; then
				echo "> stripping $xfile"
				$STRIP $xfile
			fi
		done
	else
		echo "Not stripping as requested"
	fi
	echo ".. packing"
	for i in help dev lib bin; do
		[ "$(cat ../tmp/${i}files.txt | wc -l)" -ne 0 ] && tar cvT ../tmp/${i}files.txt | xz > "${1}-${i}.${ARCH}.tar.xz"
		cat ../tmp/${i}files.txt | xargs rm || :
	done
	find . -type d -empty -delete

	echo ".. getting leftovers"
	find . -type f | sort | uniq > ../tmp/leftovers.txt
	[ "$(cat ../tmp/leftovers.txt | wc -l)" -ne 0 ] && tar cvT ../tmp/leftovers.txt | xz > "${1}-leftover.${ARCH}.tar.xz" || :
	echo ".. DONE"
}

for pkgfile in $(ls packages | sort -n); do
	source ./packages/${pkgfile}
	#rm -rf tmp/
	echo "==== Working with ${PKGNAME} @ ${PKGVERSION} ===="
	BUILD=1

	if [ -f "out/${PKGNAME}-${PKGVERSION}-bin.${ARCH}.tar.xz" -o -f "out/${PKGNAME}-${PKGVERSION}-lib.${ARCH}.tar.xz" ]; then
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
	unset PKGPATH haspackaging hasunpack SOURCEFILE URL DONTSTRIP

	tar xpf "out/${PKGNAME}-${PKGVERSION}-lib.${ARCH}.tar.xz" -C ${TARGETFS} || :
	tar xpf "out/${PKGNAME}-${PKGVERSION}-dev.${ARCH}.tar.xz" -C ${TARGETFS} || :
	tar xpf "out/${PKGNAME}-${PKGVERSION}-bin.${ARCH}.tar.xz" -C ${TARGETFS} || :
done
