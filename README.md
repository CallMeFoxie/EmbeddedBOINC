# Embedded BOINC

is a small one-purpose linux "distribution" built just for running BOINC on a PXE booted (or in theory SPI flash) node. It runs purely from initramfs, so there's no need for installing anything. Current target are small Single Board Computers like Raspberry Pi, Pine64, Orange Pi boards etc. i386/amd64 platforms are not built against right now.

## Why

Because I always wanted to build a custom linux distribution. As of right now it is very hackish (no proper packaging, but there's a reason which I will explain later).

## How

It is simple. First you build a docker container that works as your toolchain. From there you just compile all packages and then whenever however you want you just pack it all into initramfs. Remember to build kernel modules as well though!

## Hackish ways?

Yes, there's several hacks in there. For example the "packages" are packed without any postinstall/.. scripts so you have to prepare everything in `rootfiles/` for all packages beforehand. This may (and most likely will) change eventually though.

## Packages

Just look into `packages/` directory. Not all are included by default though (for example gdb)! And no manual pages nor develop files (headers, symbols, ..) are included at all in the final fs! Adding a new package is straight forward, but not everything can be overriden just yet. Eventually it will be but right now it is enough for my purpose. (See chapter Hackish ways.)

## Size

The size of the whole initramfs.zst after packing is 33MB (aarch64) or 26MB (armhf) as of right now with Prometheus exporters (node & boinc) included, alongside current 5.9 kernel modules based on the `buildsteps/configs/kernel*` configs. Remember however that all modules are after loading **REMOVED** from the initramfs to save memory! Make sure you specify all the modules you need in /etc/sysconfig/modules (or /storage/modules) for that purpose.

Do note that the initramfs eats (as of this commit) roughly 85MB RAM when running, about 100MB with BOINC. That's still pretty nice even for 512MB devices! More so considering that just Prometheus node exporter takes almost 13MB and BOINC exporter 5.2MB.

## Permanent storage

The boot process looks for partitions with labels. There is right now only one:

- `storage` -- a place to store your permanent everything, when that partition is discovered it is mounted to /storage, which may be referenced in any other further scripts. If this partition is not discovered, nothing is mounted there, so it may be used for `mountpoint` checks.

## Features on kernel command line

Right now there's several flags you can specify as kernel args that are used during the system startup:

- `uebo.hostname` -- hostname to set on startup
- `uebo.nfsdir` -- NFS4 dir that is used for /storage mount
- `uebo.boinc.password` -- remote BOINC password
- `uebo.boinc.remote_hosts` -- list of remote hosts allowed to connect (separated by comma)
- `uebo.consul` -- IP/hostname (with port) that consul listens on that will be used for auto discovery for prometheus exporters (de)registering

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

Tested that at least boot:
- ASUS Tinkerboard (Rockchip RK3288, armhf)
- Hardkernel Odroid C1+ (Amlogic S805, armhf, no network boot)
- Orange Pi PC (Allwinner H3, armhf)

Added but not tested:
- Tanix TX6 (Allwinner H6, arm64)
- Orange Pi 4 (Rockchip RK3399, arm64)

To be added when I get the time for it:
- Raspberry Pi 3 (arm64)
- a RK3399-based TV box

Boards I would like to support but don't and won't have:
- Raspberry Pi 1 and 2 (armhf)

Do note that no armhf has been tested on a live device yet as I do not have any in my drawers right now.

If you want another board supported it should be pretty easy - throw required modules into configs/kernel.conf and rebuild the kernel package and test it out. The rest should be universal. Then feel free to send me a pull request with the device :).

I also take donations in the form of devices, the distribution will be adjusted to the device as much as possible and then the device will take part in the compute cabinet.

## Tested BOINC projects

I've been crunching several projects over the recent months and so far all of them (with a bit of tweaks) all work on Embedded BOINC distro. Namely:
- TN-Grid -- aarch64 or armhf
- Rosetta@Home -- aarch64 + armhf
- World Community Grid -- armhf
- Universe@Home -- armhf
- LHC@Home -- aarch64 only
- Yoyo@Home - armhf

Projects that should work but have not been tested:
- Einstein@Home - should work if you enable beta/testing branch as the mainstream requires ancient libraries -- armhf

Projects that won't work:
- MLC@Home - requires libfuse and possibly other libraries
- anything that is not available for armhf/aarch64 platforms

Projects specified for armhf run on aarch64 platforms if you pack in armhf glibc + libgcc.

## Building and running

Everything is described in [Building](Building.md) document.

## Performance

All performance results can be found in [Benchmarks](Benchmarks.md) file. The results are added when I get a board up & running. If you want to add a board to the list, please, let me know beforehand so I can give you the same rootfs I use for testing myself!

## Monitoring

Since this distro has built-in Prometheus Node Exporter and BOINC Exporter in default profiles and support for registering into Consul autodiscovery, you can add the discovery into Prometheus scraper very easily:

```
  - job_name: node_exporter
    scrape_interval: 15s
    honor_labels: true
    consul_sd_configs:
      - server: localhost:8500
        services: 
        - node_exporter
        - boinc_exporter
```

to scrape all nodes & boinc exporters. That's it.

## License

Probably MIT or whatever you want to do with it. There's no secrets, nothing special, just a bunch of shell scripts.

## Donations

You can donate using three ways:
- on Patreon or Github to become a sponsor
- donate Hardware (contact me privately on twitter)
- I take also Gridcoin on address `SFwTSDqj9HDeG3VPF2sPHBGpg6fru5p4CZ`
