# Surface3ProArch
Linux (Arch) on the Microsoft Surface 3 Pro. Tipps and Workarounds
------
I wanted a convertible with good Linux support. After some toying with the T100TA (with like 85% of support) who is quite good but as the touchpad and touch in gerneal was flunky(2017). I could not see myself work with that. Long Term.

So here is to new beginnings with the Microsoft Surface 3 Pro.

Specs can be looked up with the ean: EAN / ISBN-13:	0885370757934.

## Short summery:

- 128GB SSD

- Intel i5 1.9-2.9 Ghz

- 4 GB RAM

- HiDPI Display

- USBB 3.0

- Mini HDMI

## Basics

1. Install all Firmware updates you can find with Windows
2. After that remove revcery Partitions, just leave the EFI Partition.
3. Download recent Anthergos Linux
4. Disable Secureboot
5. Boot Arch and install with EFI Pratition intact (with kernel 4.14 all major stuff is supported). Use EXT4.
5.a If WIFI fails during install (it should be stable afterwards) make a WUB bridge with your phone.
