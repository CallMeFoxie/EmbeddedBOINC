#!/bin/bash

ARCH=${1:-"arm64"}
ADDARCH=${ADDARCH:-""}

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

for i in glibc libgcc runit curl busybox zlib openssl boinc dropbear libcgroup htop ncurses e2fsprogs prometheus-node-exporter prometheus-boinc-exporter; do
	tar xvpf out/${i}*-bin.${ARCH}.tar.xz -C rootimage/
	tar xvpf out/${i}*-lib.${ARCH}.tar.xz -C rootimage/
#	tar xvpf out/${i}*-leftover.tar.xz -C rootimage/
done

if [ x"${ADDARCH}" != "x" ]; then
	echo "> Extra arch support: ${ADDARCH}" >> rootimage/etc/motd
	for i in glibc libgcc; do
		tar xvpf out/${i}*-bin.${ADDARCH}.tar.xz -C rootimage/
		tar xvpf out/${i}*-lib.${ADDARCH}.tar.xz -C rootimage/
	done
fi
echo "> build date: $(date)" >> rootimage/etc/motd >> rotimage/etc/motd

rm -rf tftproot
mkdir -p tftproot/pxelinux.cfg/
tar xvpf out/linux-kernel*-bin.${ARCH}.tar.xz -C tftproot "./boot/Image"
mv tftproot/boot/Image tftproot/boot/Image-${ARCH}
tar xvpf out/linux-kernel*-bin.${ARCH}.tar.xz -C tftproot --wildcards --no-anchored "*.dtb"

# kernel needs only lib package, bin has to go into tftp root
tar xvpf out/linux-kernel*-lib.${ARCH}.tar.xz -C rootimage/
(
	cd rootimage
	find . | fakeroot cpio -H newc -o > ../initramfs-${ARCH}
)
zstd initramfs-${ARCH}
rm initramfs-${ARCH}

echo "New initramfs for testing is ready!"
ls -lh initramfs-${ARCH}.zst

cp initramfs-${ARCH}.zst tftproot/
cat <<EOF >>tftproot/pxelinux.cfg/default-arm
timeout 50
default d-i
        label d-i
        linux /boot/Image-${ARCH}
        initrd /initramfs-${ARCH}.zst
EOF

(
	cd tftproot/pxelinux.cfg/
	ln -s default-arm 01-52-54-00-12-34-56
)
