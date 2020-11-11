# Benchmarks of various devices in BOINC

## Methodology

All devices are tested on identical builds (except arm64 vs armhf when applicable) of glibc 2.32, linux kernel 5.9.x branch (makes no measurable difference so far) and BOINC. Everything (if possible) is compiled with -O2 flags. All devices are booted via network or locally into initramfs -ran system.

## Results 

| device           | clock        | SoC             | cores        | arch  | Whetstone (float) | Dhrystone (int) |
|------------------|--------------|-----------------|--------------|-------|-------------------|-----------------|
| Pine64+          | 1.152GHz     | Allwinner A64   | 4xA53        | arm64 | 1227              | 3421            |
| Orange Pi PC     | 1.368GHz     | Allwinner H3    | 4xA7         | armhf | 1028              | 3305            |
| Odroid C1+       | 1.5GHz       | Amlogic S805    | 4xA5         | armhf | 1070              | 2956            |
| ASUS Tinkerboard | 1.8GHz       | Rockchip RK3288 | 4xA17        | armhf | 1626              | 6203            |
| Orange Pi 4      | 2GHz, 1.5GHz | Rockchip RK3399 | 2xA72, 4xA53 | arm64 |                   |                 |
| H96 Max TV box   |              | Rockchip RK3399 | 2xA72, 4xA53 | arm64 |                   |                 |
| Tanix TX6        | 1.8GHz       | Allwinner H6    | 4xA53        | arm64 |                   |                 |
| Orange Pi Zero   | 1.1GHz       | Allwinner H2    | 4xA7         | armhf |                   |                 |
