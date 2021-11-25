# Benchmarks of various devices in BOINC

## Methodology

All devices are tested on identical builds (except arm64 vs armhf when applicable) of glibc 2.32, linux kernel 5.9.x branch (makes no measurable difference so far) and BOINC. Everything (if possible) is compiled with -O2 flags. All devices are booted via network or locally into initramfs -ran system.

**5.10 branch**: In the process of switching to glibc 2.33 and linux kernel 5.10.x branches the results may vary a bit, upto 10% from current benchmarks.

**5.15 branch**: So far all devices benchmark roughly 10 - 15% higher Whetstone and 2 - 5% lower Dhrystone benchmarks. The only change was kernel between benchmarks.

## Results 

| device           | clock        | SoC             | cores        | arch  | Whetstone (float) | Dhrystone (int) | Tested 5.10.x | Tested 5.15.x |
|------------------|--------------|-----------------|--------------|-------|-------------------|-----------------|---------------|---------------|
| Pine64+          | 1.152GHz     | Allwinner A64   | 4xA53        | arm64 | 1227              | 3421            |      X        |      X        |
| SOPine64         | 1.152GHz     | Allwinner A64   | 4xA53        | arm64 | 1244              | 3422            |      X        |      X        |
| Orange Pi PC     | 1.368GHz     | Allwinner H3    | 4xA7         | armhf | 1028              | 3305            |      X        |               |
| Odroid C1+       | 1.5GHz       | Amlogic S805    | 4xA5         | armhf | 1070              | 2956            |      X        |      X        |
| ASUS Tinkerboard | 1.8GHz       | Rockchip RK3288 | 4xA17        | armhf | 1626              | 6203            |      X        |               |
| Orange Pi 4      | 2GHz, 1.5GHz | Rockchip RK3399 | 2xA72, 4xA53 | arm64 | 2793, 1630        | 10661, 4486     |      X        |               |
| H96 Max TV box   | 2GHz, 1.5GHz | Rockchip RK3399 | 2xA72, 4xA53 | arm64 | 2786, 1629        | 11537, 4484     |      X        |      X        |
| Tanix TX6        | 1.8GHz       | Allwinner H6    | 4xA53        | arm64 | 1941              | 4910            |      X        |               |
| Orange Pi Zero   | 1.1GHz       | Allwinner H2    | 4xA7         | armhf |                   |                 |               |               |
| Raspberry Pi 3B  | 1.2GHz       | Broadcom 2837   | 4xA53        | arm64 | 1286              | 3544            |      X        |      X        |
| Raspberry Pi 4B  | 1.5GHz       | Broadcom 2711   | 4xA72        | arm64 | 2071              | 8628            |      X        |               |
