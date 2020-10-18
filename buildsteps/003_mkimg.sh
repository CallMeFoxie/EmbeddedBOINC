#!/bin/bash

rm -rf rootimage initramfs initramfs.gz
mkdir -p rootimage

cp -rpd rootfiles/* rootimage/

for i in glibc libgcc runit curl busybox zlib openssl boinc; do
	tar xvpf out/${i}*-bin.tar.xz -C rootimage/
	tar xvpf out/${i}*-lib.tar.xz -C rootimage/
done

(
	cd rootimage
	find . | cpio -H newc -o > ../initramfs
)
gzip initramfs

echo "New initramfs for testing is ready!"
ls -lh initramfs.gz
