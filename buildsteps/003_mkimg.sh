#!/bin/bash

set -eu

PLATFORM=${1:-"default-arm64"}

source platform/${PLATFORM}.cfg

rm -rf rootimage initramfs*
mkdir -p rootimage

cp -rpd rootfiles/* rootimage/

cat <<EOF >> rootimage/etc/motd
  ______           _              _     _          _   ____   ____ _____ _   _  _____ 
 |  ____|         | |            | |   | |        | | |  _ \\ / __ |_   _| \\ | |/ ____|
 | |__   _ __ ___ | |__   ___  __| | __| | ___  __| | | |_) | |  | || | |  \\| | |     
 |  __| | '_ \` _ \\| '_ \\ / _ \\/ _\` |/ _\` |/ _ \\/ _\` | |  _ <| |  | || | | . \` | |     
 | |____| | | | | | |_) |  __| (_| | (_| |  __| (_| | | |_) | |__| _| |_| |\\  | |____ 
 |______|_| |_| |_|_.__/ \\___|\\__,_|\\__,_|\\___|\\__,_| |____/ \\____|_____|_| \\_|\\_____|
                                                                                      
                                                                                      
EOF

echo "=== welcome to Embedded BOINC shell ===" >> rootimage/etc/motd

for i in ${BASEPKGS}; do
	tar xvpf out/${i}*-bin.${BASEARCH}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-bin.${BASEARCH}.tar.xz) >> rootimage/var/pkgs.txt || :
	tar xvpf out/${i}*-lib.${BASEARCH}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-lib.${BASEARCH}.tar.xz) >> rootimage/var/pkgs.txt || :
done

echo "> arch support: ${BASEARCH} ${EXTRAARCHS}" >> rootimage/etc/motd
for arch in ${EXTRAARCHS}; do
	for i in glibc libgcc; do
		tar xvpf out/${i}*-bin.${arch}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-bin.${arch}.tar.xz) >> rootimage/var/pkgs.txt || :
		tar xvpf out/${i}*-lib.${arch}.tar.xz -C rootimage/ 2>/dev/null && echo $(ls out/${i}*-lib.${arch}.tar.xz) >> rootimage/var/pkgs.txt || :
	done
done

echo "> build date: $(date)" >> rootimage/etc/motd

rm -rf tftproot
mkdir -p tftproot/pxelinux.cfg/
tar xvpf out/linux-kernel*-bin.${BASEARCH}.tar.xz -C tftproot "./boot/Image"
mv tftproot/boot/Image tftproot/boot/Image-${BASEARCH}
tar xvpf out/linux-kernel*-bin.${BASEARCH}.tar.xz -C tftproot --wildcards --no-anchored "*.dtb"

# kernel needs only lib package, bin has to go into tftp root
tar xvpf out/linux-kernel*-lib.${BASEARCH}.tar.xz -C rootimage/
(
	cd rootimage
	find . | fakeroot cpio -H newc -o > ../initramfs-${BASEARCH}
)
zstd initramfs-${BASEARCH}
rm initramfs-${BASEARCH}

echo "New initramfs for testing is ready!"
ls -lh initramfs-${BASEARCH}.zst

cp initramfs-${BASEARCH}.zst tftproot/
cat <<EOF >>tftproot/pxelinux.cfg/default-arm
timeout 50
default d-i
        label d-i
        linux /boot/Image-${BASEARCH}
        initrd /initramfs-${BASEARCH}.zst
EOF

(
	cd tftproot/pxelinux.cfg/
	ln -s default-arm 01-52-54-00-12-34-56
)
