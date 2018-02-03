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

## Basic Installation

1. Install all Firmware updates you can find with WIDNOWS.
2. After that remove recovery Partitions, just leave the EFI Partition. (Has ca 300mb at the beginning of the disak empty)
3. Download recent Anthergos Linux
4. Disable Secureboot
5. Boot Arch and install with EFI Partition intact (with kernel 4.14 all major stuff is supported). Use BTRFS.
5. a) If WIFI fails during install (it should be stable afterwards USE 5Ghz WIFI!) make a USB bridge with your phone.

## Install Surface kernel and power tools

6. Install some stuff:

pacman -Syu powertop laptop-detect yaourt pavucontrol

7. Deactivate tmpfs (uses too much valuable ram and can NOT build kernel in it!)

systemctl mask tmp.mount

Download the snapshot of laptop-mode-tools

-> https://aur.archlinux.org/packages/laptop-mode-tools/

8. Build laptop-mode-tools with makepkg then install the pakage makepkg --install

9. Build and install surface Kernel

yaourt -S linux-surfacepro3-git

10. While this is running change system Language to English and leave the Input to German keayboard.

nano /etc/locale.gen uncomment

en_US.UTF-8 UTF8

en_DK.UTF-8 UTF8 # gives European Units and A4 Paper size

locale-gen

Change in Gnome Settings.


