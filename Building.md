# Building Embedded BOINC

As of right now there are no pre-built images, you have to build EmbeddedBOINC yourself. But no worries, it is not hard, all you need is some HDD space (let's say 15 gigs -ish), Docker and internet connection!

## 1. Build cross tools

First you need to build cross tools. In the `dockerbuilder` directory just build the two docker images. `docker build --pull -t uebo-cross-arm64 -f Dockerfile.arm64 .` and the same for armhf. This will take some time, on Ryzen 2700 limited to 12 threads it runs about 20 minutes.

## 2. Building all packages

Now start your docker container via `docker run --rm -ti -v `pwd`:/sources2 uebo-cross-arm64` and in the container cd into `buildsteps` directory. From there just issue `./002_buildpkgs.sh`. Do the same with armhf, if you want both arm64 and armhf packages.

## 3. Do your changes in `rootfiles`

Do whatever edits you want in rootfiles. Edit etc/sysconfig/modules, edit service files, network scripts, add ssh authorized keys, change password, anything you want!

## 3. Building target image

Almost done! Now you just need to package all the stuff into initramfs. Issue `./003_mkimg.sh yourplatform`. If you don't see your platform in the list, go into `platform` directory and make one! it is just a matter of selecting the right DTB, architecture (arm64 vs arm) and package list.

## 4. Booting

The final step is the easiest. The same way as any other linux distribution the EmbeddedBOINC needs to be booted. Just feed the generated `initramfs*.zst` and `Image` to U-Boot either via local SD card or via PXE and you're done!
