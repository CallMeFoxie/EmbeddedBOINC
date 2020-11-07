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

Do note that the initramfs eats (as of this commit) roughly 45MB RAM when running. That's still pretty nice even for 512MB devices! More so considering that just Prometheus node exporter takes almost 13MB and BOINC exporter 5.2MB.

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

## Supported platforms platforms

Right now this is being developed against aarch64 and armhf, maybe eventually also amd64. No other archs are (from me) planned as of right now.

Target devices that are thoroughly tested and developed against:
- SOPine64 clusterboard (Allwinner A64, arm64)
- Pine64+ (Allwinner A64, arm64)
- QEMU (only for testing and development) (Generic Cortex A53 with AMBA PL011 serial driver + e1000, arm64)

Added but not tested:
- Tanix TX6 (Allwinner H6, arm64)
- Orange Pi 4 (Rockchip rk3399, arm64)

To be added when I get a development boards:
- Raspberry Pi 3 (arm64)
- Odroid C1 (armhf)

Boards I would like to support but don't and won't have:
- Raspberry Pi 1 and 2 (armhf)

Do note that no armhf has been tested on a live device yet as I do not have any in my drawers right now.

If you want another board supported it should be pretty easy - throw required modules into configs/kernel.conf and rebuild the kernel package and test it out. The rest should be universal. Then feel free to send me a pull request with the device :).

## Tested BOINC projects

I've been crunching several projects over the recent months and so far all of them (with a bit of tweaks) all work on Embedded BOINC distro. Namely:
- TN-Grid -- aarch64 only
- Rosetta@Home -- aarch64 required, but apparently requires also armhf glibc + libgcc
- World Community Grid -- armhf only (or aarch64 with armhf glibc + libgcc)
- Universe@Home -- armhf only (or aarch64 with armhf glibc + libgcc)

Projects that should work but have not been tested:
- LHC@Home - should work, waiting for some SixTrack jobs to appear -- aarch64 only
- Yoyo@Home - should work, but I am not crunching that -- armhf only (or aarch64 with armhf glibc + libgcc)
- Einstein@Home - should work if you enable beta/testing branch as the mainstream requires ancient libraries -- armhf only (or aarch64 with armhf glibc + libgcc)


## 32bit userland on 64bit platform

By default 64bit platforms (arm64) contain only 64bit userland (glibc, ...) but you can request adding 32bit userland (glibc and libgcc) as well by specifying `ADDARCH=arm` environment variable. This will add ~17MB memory usage though!

## License

Probably MIT or whatever you want to do with it. There's no secrets, nothing special, just a bunch of shell scripts.
