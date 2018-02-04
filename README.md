# Surface3ProArch
Linux (Arch) on the Microsoft Surface 3 Pro. Tipps and Workarounds
------
I wanted a convertible with good Linux support. After some toying with the T100TA (with like 85% of support) who is quite good but as the touchpad and touch in gerneal was flunky(2017). I could not see myself work with that. Long Term.

So here is to new beginnings with the Microsoft Surface 3 Pro. I will use the Gnome desktop for best touch support.

Specs can be looked up with the ean: EAN / ISBN-13:	0885370757934

## Short summery:

- 128GB SSD

- Intel i5 1.9-2.9 Ghz

- 4 GB RAM

- HiDPI Display

- USBB 3.0

- Mini HDMI

## Basic Installation

1. Install all Firmware updates you can find with WIDNOWS.
2. After that remove recovery partitions, just leave the EFI Partition. (Has around 300mb at the beginning of the disak empty)
3. Download recent Anthergos Linux -> https://antergos.com/
4. Disable Secureboot
5. Boot Arch and install with EFI Partition intact (with kernel 4.14 all major stuff is supported). 
  5. A) Use BTRFS for better SSD support.
  5. B) If WIFI fails during install (it should be stable after the fix!) make a USB bridge with your phone.
  5. C) Make sure AUR is activated
6. Reboot into installed system

## Install Surface kernel and power tools

### Install some stuff:

`pacman -Syu powertop laptop-detect yaourt pavucontrol`

### Deactivate tmpfs 
(uses too much valuable ram and can NOT build kernel in it!)

`systemctl mask tmp.mount`

reboot.

### Download the snapshot of laptop-mode-tools 
It is flagged outdated for some reason but it is still developed. :-)

-> https://aur.archlinux.org/packages/laptop-mode-tools/

### Build laptop-mode-tools 
with `makepkg` then install the pakage `makepkg --install`

### Build and install surface Kernel

`yaourt -S linux-surfacepro3-git`

This downloades the new 4.15 kernel with surface 3 pro patches. You can still make adjustments to the config.

Make a grub.cfg

`grub-mkconfig -o /boot/grub/grub.cfg`

Change the kernel line to the surface kernel ones

`initramfs-linux.img` to `initramfs-linux-surfacepro3-git.img`

`vmlinux` to `vmlinux-surfacepro3-git` in the grub.cfg

After that reboot the System.

## Fix Wifi

Make sure you use 5 Ghz Wifi as the USB 3.0 can interfere with 2.4Ghz stability!

Put the following in `/etc/NetworkManager/NetworkManager.conf` to make it permanent. This will disable both power management and MAC randomization:

`[connection]`

`wifi.powersave=2  # 2=disable`

`wifi.mac-address-randomization=1 # 1=disable`

`wifi.cloned-mac-address=permanent`

`[device]`

`wifi.scan-rand-mac-address=no`

## Switch suspend for hibernate

Suspend is broken on newer systems so we switch it for hibernate.

`sudo rm -Rf /etc/systemd/system/suspend.target && sudo ln -sf /usr/lib/systemd/system/hibernate.target /etc/systemd/system/suspend.target`

`sudo rm -Rf /etc/systemd/system/systemd-suspend.service && ln -sf /usr/lib/systemd/system/systemd-hibernate.service /etc/systemd/system/systemd-suspend.service`

## Install GDM

GDM has better touch support than lightdm greeters, so you can boot the in Tablet mode and still log in.

`pacman -Syu gdm`

To start GDM at boot time enable gdm.service

`systemctl enable gdm.service`

Gnome will start in a wayland session first. Make sure you use Xorg for best experience.

## Reenable Secure Boot

### Install systemd Boot
Make sure /boot/efi/ is mounted (EFI Folder inside)

`bootctl --path=/boot/efi install`

Install the signed gummiboot loader.

`yaourt -S preloader-signed`

Then copy it to the right places.

`cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/efi/EFI/systemd`

Now copy over the boot loader binary and rename it to loader.efi; for systemd-boot use:

`cp /boot/efi/EFI/systemd/systemd-bootx64.efi /boot/efi/EFI/systemd/loader.efi`

Finally, create a new NVRAM entry to boot PreLoader.efi:

`efibootmgr --disk /dev/sda --part 1 --create --label "PreLoader" --loader /EFI/systemd/PreLoader.efi`

Replace X with the drive letter and replace Y with the partition number of the EFI System Partition.

This entry should be added to the list as the first to boot; check with the efibootmgr command and adjust the boot-order if necessary.

#### Fallback
If there are problems booting the custom NVRAM entry, copy HashTool.efi and loader.efi to the default loader location booted automatically by UEFI systems:

`cp /usr/share/preloader-signed/HashTool.efi /boot/efi/EFI/Boot`

`cp esp/EFI/systemd/systemd-bootx64.efi /boot/efi/EFI/Boot/loader.efi`

Copy over PreLoader.efi and rename it:

`cp /usr/share/preloader-signed/PreLoader.efi /boot/efi/EFI/Boot/bootx64.efi`

For particularly intransigent UEFI implementations, copy PreLoader.efi to the default loader location used by Windows systems:

`mkdir -p esp/EFI/Microsoft/Boot`

`cp /usr/share/preloader-signed/PreLoader.efi esp/EFI/Microsoft/Boot/bootmgfw.efi`

__Note:__ If dual-booting with Windows, backup the original bootmgfw.efi first as replacing it may cause problems with Windows updates. As before, copy HashTool.efi and loader.efi to esp/EFI/Microsoft/Boot/.

When the system starts with Secure Boot enabled, follow the steps above to enroll loader.efi and /vmlinuz-linux (or whichever kernel image is being used).

## Optimizations

While the kernel in compiling we have some time to do some system optimizations :-)

### Change system Language to English and leave the Input to German keayboard.

`nano /etc/locale.gen` uncomment

`en_US.UTF-8 UTF8`

`en_DK.UTF-8 UTF8 # gives European Units and A4 Paper size`

`locale-gen`

Change in Gnome Settings.

### Deactivate Gnome file tracking
Saves a bit of RAM.

Just deactivate all the "Search" Options in the Gnome Settings.


