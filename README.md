# Embedded BOINC

is a small one-purpose linux "distribution" built just for running BOINC on a PXE booted (or in theory SPI flash) node. It runs purely from initramfs, so there's no need for installing anything.

## Why

Because I always wanted to build a custom linux distribution. As of right now it is very hackish (no proper packaging, but there's a reason which I will explain later).

## How

It is simple. First you build a docker container that works as your toolchain. From there you just compile all packages and then whenever however you want you just pack it all into initramfs. Remember to build kernel modules as well though!

## Hackish ways?

Yes, there's several hacks in there. For example the "packages" are packed without any postinstall/.. scripts so you have to prepare everything in `rootfiles/` for all packages beforehand. This may (and most likely will) change eventually though.

## Packages

Just look into `packages/` directory. Not all are included by default though (for example gdb)! And no manual pages nor develop files (headers, symbols, ..) are included at all in the final fs! Adding a new package is straight forward, but not everything can be overriden just yet. Eventually it will be but right now it is enough for my purpose. (See chapter Hackish ways.)

## Size

The size of the whole initramfs.gz after packing is 25MB as of right now with Prometheus exporters (node & boinc) included. If you add in default debian 4.19 aarch64 modules it goes upto 77MB! You're better off baking the current 5.9 kernel with custom set of modules instead. Remember however that all modules are after loading **REMOVED** from the initramfs to save memory for BOINC! Make sure you specify all the modules you need in /etc/modules (or /conf/modules for that purpose).

## Permanent storage

The boot process looks for partitions with labels. There are as of right now two of them:

- `conf` -- a place to store your /etc configuration, when that partition is discovered it is mounted to /conf and everything from /conf/* is symlinked to /etc/*.
- `boinc` -- a place to store all the boinc runtime data, when that partition is discovered it is mounted to /var/lib/boinc-data. Do not that BOINC startup checks for this mountpoint so if it doesn't exist it doesn't start up as a safety measure!

## Init system

Since systemd is far too big for this purpose and sysvinit is too ... not usable for me :) I used `runit` instead. It provides everything I need and more. Most tools are provided by busybox with some exceptions from e2fsprogs.

## Why not crosstools-ng, linaro; buildroot, openwrt, yocto, ...

Because it felt like it was too much hassle to get into somebody else's scripts and ways of doing. This was whipped up in a few hours and then gradually expanded as I needed. Read "Why".

## Debugging

`qemu-system-aarch64 -m 1024 -machine virt -cpu cortex-a53 -bios u-boot.bin -nographic -device e1000,netdev=mynet0 -netdev user,id=mynet0,tftp=/var/lib/tftpboot/,hostfwd=tcp::5555-:22` is one way... or just boot directly on some node :)

## Tested platforms

Right now this is being developed purely against aarch64, maybe eventually also amd64. No other archs are (from me) planned as of right now.

## License

Probably MIT or whatever you want to do with it. There's no secrets, nothing special, just a bunch of shell scripts.
