#!/bin/bash

sudo qemu-system-aarch64 -m 4096 -machine virt -cpu cortex-a53 -bios u-boot.bin -nographic -device e1000,netdev=mynet0 -netdev user,id=mynet0,tftp=$(pwd)/tftproot/,hostfwd=tcp::5555-:22
