# Surface3ProArch
Linux (Arch) on the Microsoft Surface 3 Pro. Tipps and Workarounds
------
I wanted a convertible with good Linux support. After some toying with the T100TA (with like 85% of support) who is quite good but as the touchpad and touch in gerneal was flunky(2017). I could not see myself work with that. Long Term.

So here is to new beginnings with the Microsoft Surface 3 Pro. I will use the Gnome desktop for best touch support.

# TODO:
* ~~Get the eraser of the pen to work (HELP NEEDED!!! :)~~ 
  * It turns out that the surface 3 Pen has no eraser on the top.
* ~~Powertop script - multiple runs, check if on battery~~
* ~~Figure out Gnome Autostart~~
* ~~Make xjournal fullscreen and foreground~~ (DEPREACHED: use Write instead:)
* ~~VM Writeback seconds!~~
* ~~Deactivate Gnome Virt Keyboard on single click~~
  * Use Onboard instead!
   * Test new keybiard from Gnome 3.28
* Make Udev Rule do something cool when Typecover conects
* ~~Make Krita useable with the stylus~~ works with X11 not with Wayland
* Optimise scripts for powersave (5 hours instad of 7 without the scripts)
* Better backlight script
* Kernel powersave
* Touchscreen Apps :-)
* install DIR colors
* ~~Grub2 keyboard hack, UEFI Keyboard?~~
* ~~TTY Console Fronts~~
* More touch gestures (fusuma, libinput, ginn, touchegg??)
* ~~Look into Write APP SysLabs~~
* ~~Power button behaviour script~~
* Make the Stylus semi-Autoconnect with a script
* ~~FN Shortcuts for display birghtness~~
* Make the Pen unlock/wakeup the screen
* ~~Rotate does not work with HIDPi scaleing of X11. Correct Wiki~~
* start Palmreject only when pen is found -> Udev rule ?
* ~~Check if laptop mode tools are active ? Powertop related?~~
* ~~GTK2 Wrapper script!~~
* ~~Onboard integration in gnomeshell~~
* Better Gnome expirence (less child like desktop)
  * Show guake if mouse is in top corner
  * https://extensions.gnome.org/extension/1267/no-title-bar/
  * https://extensions.gnome.org/extension/503/always-zoom-workspaces/


## Hardware Info

- 128GB SSD

- Intel i5 1.9-2.9 Ghz

- 4 GB RAM

- HiDPI Display

- USBB 3.0

- Mini HDMI

Specs can be looked up with the ean: EAN / ISBN-13: 0885370757934

## Grub2 Softkeyboard

To get a keyboard in Grub2,you have to set it in the uefi bios to always show itself. Then it will show, when the keyboard is NOT attached and you boot the surface fresh up. Its a little small but it gets the job done to select what you want to boot.

If you use any other setting than "always" in the UEFI it will not show up! It also does not show, when it detects a keyboard on the surface wich is acutally a good thing i think.

## Basic Installation

1. Install all Firmware updates you can find with WIDNOWS.
2. After that remove recovery partitions, just leave the EFI Partition. (Has around 300mb at the beginning of the disak empty)
3. Download recent Anthergos Linux -> https://antergos.com/
4. __Disable Secureboot__ (we will reenable it later)
5. Boot Arch and install with EFI Partition intact (with kernel 4.14 all major stuff is supported). 
  .. A) Use BTRFS for better SSD support.
  .. B) If WIFI fails during install (it should be stable after the fix!) make a USB bridge with your phone.
  .. C) Make sure AUR is activated
6. Reboot into installed system

## Install Surface kernel and power tools

### Install some stuff:

`pacman -Syu powertop laptop-detect pacaur pavucontrol`

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

__NOTE: The 4.15 kernel in the arch repo seems to support most stuff right now, maybe not needed anymore...__

`pacaur -S linux-surfacepro3-git`

This downloades the new 4.15 kernel with surface 3 pro patches. You can still make adjustments to the config.

Make a grub.cfg

`grub-mkconfig -o /boot/grub/grub.cfg`

Change the kernel line to the surface kernel ones

`initramfs-linux.img` to `initramfs-linux-surfacepro3-git.img`

`vmlinux` to `vmlinux-surfacepro3-git` in the grub.cfg

After that reboot the System.

## Fix Wifi disconnect

Make sure you use 5 Ghz Wifi as the USB 3.0 can interfere with 2.4Ghz stability!

Put the following in `/etc/NetworkManager/NetworkManager.conf` to make it permanent. This will disable both power management and MAC randomization:

    [connection]  
    wifi.powersave=2  # 2=disable  
    wifi.mac-address-randomization=1 # 1=disable  
    wifi.cloned-mac-address=permanent

    [device]  
    wifi.scan-rand-mac-address=no

## Suspend and Hibernate

After some testing it seems that hibernate and secureboot do not work well togehter.
For that reason i will not go into detail about hibernation here. 

After all it boots fast with SSD and with Hibernate there are different issues with wifi and touchscreen not coming up again. 

### Deactivate Hibernate and Suspend

`systemctl mask hibernate.target`  
`systemctl mask suspend.target`

Also edit /default/grub and remove the resume line in the DEFAULTS section.

### Type Cover Lid Close behaviour

Edit `/etc/systemd/logind.conf `

Change that line to: 

`HandleLidSwitch=poweroff`

So you can power down the Tablet with the Type Cover closeing.

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

`pacaur -S preloader-signed systemd-boot-pacman-hook`

Then copy it to the right places.

`cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/efi/EFI/systemd`

Now copy over the boot loader binary and rename it to loader.efi; for systemd-boot use:

`cp /boot/efi/EFI/systemd/systemd-bootx64.efi /boot/efi/EFI/systemd/loader.efi`

Finally, create a new NVRAM entry to boot PreLoader.efi:

`efibootmgr --disk /dev/sda --part 1 --create --label "PreLoader" --loader /EFI/systemd/PreLoader.efi`

This entry should be added to the list as the first to boot; check with the efibootmgr command and adjust the boot-order if necessary.

#### Fallback
If there are problems booting the custom NVRAM entry, copy HashTool.efi and loader.efi to the default loader location booted automatically by UEFI systems:

`cp /usr/share/preloader-signed/HashTool.efi /boot/efi/EFI/Boot`

`cp /boot/efi/EFI/systemd/systemd-bootx64.efi /boot/efi/EFI/Boot/loader.efi`

Copy over PreLoader.efi and rename it:

`cp /usr/share/preloader-signed/PreLoader.efi /boot/efi/EFI/Boot/bootx64.efi`

For particularly intransigent UEFI implementations, copy PreLoader.efi to the default loader location used by Windows systems:

`mkdir -p /boot/efi/EFI/Microsoft/Boot`

`cp /usr/share/preloader-signed/PreLoader.efi /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi`

When the system starts with Secure Boot enabled, follow the steps above to enroll loader.efi.

### Configure Secureboot 

At this stage Secureboot will load the systemd loader binary wich will give us a selection menu to choose from what to boot.

You can direcly boot a kernel (secure method, but you need to hash the kernel!) or boot into normal Grub2.

To chainload Grub2 create:

`/boot/efi/loader.conf` with

`default arch` and safe the file.

Then create `/boot/efi/entries/arch.conf` with this in it:

    title Arch Linux  
    efi EFI/antergos_grub/grubx64.efi

Then update the boot entries:

`bootctl update`

When you reboot you will have to activate secureboot hash the grubx64.efi binary with the hash tool. After that you can boot grub with secureboot active.

## Stylus

Install the  `pacman -S xf86-input-wacom` package and make these files:

`/etc/X11/xorg.conf.d/50-wacom.conf:`

    Section "InputClass"  
      Identifier      "Surface Wacom"  
      MatchProduct    "1B96:1B05 Pen"  
      MatchDevicePath "/dev/input/event*"  
      Driver          "wacom"`  
      Option          "RandRRotation" "on"  
      Option          "Button2" "3"  
      Option          "Button3" "2"  
    EndSection

`/etc/X11/xorg.conf.d/52-wacom-options.conf:`

    Section "InputClass"  
      Identifier "NTRG0001:01 1B96:1B05 Pen stylus"  
      Option "TPCButton" "on"  
    EndSection  

### Krita and Xrandr scaling

It seems Mypaint does handle the scaleing of the desktop with xrandr much better than krita does.

Krita will not allow you to use the full screen (1.25*) of the scaled down version and you only can und 1.0 wich means not all areas in your canvas will be reachable (no --panning support in xsetwacom or whatever). In short Krita can not be used if you plan on useing a scaled desktop. 

If you are like me an Krita is your new favourite Art tool we have to do the following:

- Create a session launcher for Krita and then don't scale the desktop. This way we can do some extra stuff too.

Create  `usr/share/xsessions/krita.desktop`:

    [Desktop Entry]
    Name=Krita Session on Xorg
    Comment=Joh Doe
    Exec=env KRITAS=yes gnome-session 
    TryExec=gnome-session
    Icon=
    Type=Application
    DesktopNames=GNOME

This will let us know that this desktop is a krita session then.

### Bluethooth 

Modify `/lib/systemd/system/bluetooth.service`, changing the Exec line to this:

`ExecStart=/usr/libexec/bluetooth/bluetoothd --experimental`

Adding the "experimental" line will let things like Bose products work with bluetooth, also it will rediscover the pen after a reboot, so you dont have to pait it again.

### Palmreject

MyPaint has an option to turn the touchscreen off or use it just with features you want.

However if you put your palm onto someting that is not canvas a touch is triggerd. So be careful how you daw or use the palmreject script from here. 

This script was modified to work with the pens that come with the SP3.

### Top Stylus Button

Use the `pen_click.sh` script from here to make this work. You need a SUDO rule for btmon (see sudo rules)

Start the sript like this:

`sudo btmon | ./pen_click.sh &`

## Backlight and Rotation

Just install iio-sensor-proxy-git from AUR to get the rotation and the backlight light sensor up and running.

`pacaur -S iio-sensor-proxy-git`

To match the screen rotation with the sytlus execute the `rotate_stylus.sh` script from here. 
Put it in Gnome Autosttart if you want.

### Keyboard backlight control

You need to download the script and make some custom Keyboard shortcuts with Gnome to make it work with the Buttons.

Sadly you can not use the F1 or F2 Buttons because they will not send and event to the Kernel and are most likely internally managed. Thanks Microsoft....

This scripts needs some improvement! Volunteers ?

## ScreenDPI

Make a monitor config:

`nano /etc/X11/xorg.conf.d/90-monitor.conf`
    
    Section "Monitor"
      Identifier             "<default monitor>"
      DisplaySize            253 169 # In millimeters
    EndSection

and create an autostart script:

`~./config/autostart/hidpi`

    #!/bin/bash
    if [ -z "$KRITAS" ]; then 
    # env does not exist - normal scaled session
    sleep 4
    xrandr --dpi 192
    xrandr --output eDP-1 --scale 1.25x1.25 &
    sleep 1
    xrandr --output eDP-1 --scale 1.25x1.25 --panning 2160x1440
    sleep 1
    gsettings set org.gnome.desktop.background show-desktop-icons true
    gsettings set org.gnome.desktop.background show-desktop-icons false
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    else
    # env exist krita session
    # noscaling stylus gets messed up
    sleep 3
    gtkwrapper krita --fullscreen &
    fi
  
Make it executeable:
  
 `chmod +x ~./config/autostart/hidpi`
 
__NOTE:__ Be aware that the xrandr scaling does __NOT work__ correctly when you rotate the screen! It will leave you with a scaling factor of 2 and when you return back, the orginal orientation will be too small. For now i don't know how to get this fixed.

__I opented to deactivate rotation of the Desktop, as I rarely use it:__

`gsettings set org.gnome.settings-daemon.plugins.orientation active false`

### GTK+ 2

To get bigger icons in xournal and other GTK2 apps.

This will only work in a non-scaled version of the Desktop!

Add this stuff to `~.gtkrc-2.0`:

    gtk-icon-sizes = "panel-menu=32,32:panel=32,32:gtk-menu=32,32\
    :gtk-large-toolbar=32,32:gtk-small-toolbar=32,32:gtk-button=32,32"

Next copy the gtkwrapper from here to /usr/local/bin/

`sudo cp gtkwrapper /usr/local/bin`

### Gnome Autostart

As Gnome does not support to start a bash script at login we have to do some trickery:

Create: `~./config/autostart/script.desktop`

    [Desktop Entry]
    Type=Application
    Exec=/home/user/.config/autostart/hidpi
    Hidden=false
    X-GNOME-Autostart-enabled=true
    Name=ScriptAutostart
    Comment=Silly Gnome way to do it

Now when this is done, you can check with the Gnome Tweak tool if it should start on login.

If it is listed, we are nearly there. 
As Gnome tries to mimic Windows we need to trust the application once so it will be exectured. 

To do that, just go with Nautlius in the autostart folder and execute the .desktop file once.

### TTY Consoles

To get a bigger font in the TTYs change `/etc/vconsole.conf`:

    /etc/vconsole.conf
    FONT=sun12x22
    KEYMAP=de

To use the specified font in early userspace, use the `consolefont` hook in `/etc/mkinitcpio.conf`.

And rebuild the init: `pacman -S linux`

## Replace the virtual keyboard

As Caribou the OSK of Gnome has some uggly bugs who make it appear virtually everywhere. Its best to replace it:

`pacman -Syu onboard`

Also you need these extensions:   
-> https://extensions.gnome.org/extension/1326/block-caribou/  
-> https://extensions.gnome.org/extension/992/onboard-integration/?c=35203

Make sure you also activate the "Onboard Indicator" extension from the default install. Now you should get onboard or you can activate it with the buttin in the shell.

__Best options in the onboard-settings:__
- Glue to the top border of the screen
- Compact layout
- Nightshade Theme fits nicely into Gnome.

## Battery life

To get longer battery life we need to make the screen turn off when wen want to. My battery went up from 3 hours to 7 hours :-)

### Disable Bluethooth

An active Bluethooth chip can shorten your Batter live up to 40 % so make sure it is OFF if you dont need it!

### Make Gnome shutdown on battery 

When Gnome is on battery, it gives you the choice to hibernate or suspend the laptop aftetr some time of inactivity.
As both are no options for us, we need to tinker with the Gnome registry:

Use dconf-editor to navigate to: `org.gnome.settings-daemon.plugins.power`

Here go into: `sleep-inactive-battery-type` 

In Custom Value, set `shutdown`

If you want you can set the timeout also, standard is 15 minutes (900 seconds)

Also make sure to set `sleep-inactive-ac-type` to `blank` and the timeout for AC action to 300.

For some reason, this does also work when on battery and will blank the screen after some time..

### Sudo rules for powertop

Edit the sudoers file with this (very end of the file!):

`user ALL=NOPASSWD: /usr/bin/powertop, /bin/btmon`

Now powertop and btmon should function without password required.

### Powertop

Laptop mode tools handels the activation of powertop. No need to do it by hand.

### Power optimizations

For some reason some settings from powertop will not be set when you use the autotune feature.

Create this file: `/etc/sysctl.d/vm.conf` with

    vm.dirty_writeback_centisecs = 6000
    vm.laptop_mode = 5    

This will reduce disk write and save power.

Create `/etc/modprobe.d/audio_powersave.conf`:

    options snd_hda_intel power_save=1
    
To reduce Audio codec power consumption.
 
Edit the `fstab` and add `commit=60` as a option in fstab after your filesystem mounts to match with the writebacks from above.

Add `nmi_watchdog=0` to the DEFAULT kernel line in `/etc/default/grub` to disable it completely from boot. Then rebuild Grub.cfg with `grub-mkconfig -o /boot/grub/grub.cfg`

#### Turn off Webcams

If you don't want to use the webcams, turn them off in the UEFI Bios.

### Power Button turns screen off

To accomplish this feat you have to do some tinkering as the GNOME Devs think the user is a child who should not do some stuff with its power button behaviour....

Install the acpid to run powertop when you disconnect the AC Power, together with the systemd service this should cover most use cases.

`pacman -S acpi`

Enable the acpid.servive

`systemctl enable acpid.servive`

In `/etc/systemd/logind.conf` set 

`HandlePowerKey=ignore`

Next make Gnome do nothing with the button.

`gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'nothing'`

Then create this file: 

    /etc/acpi/screenoff.sh
    #!/bin/bash
    #Script to simulate normal power button actions with gnome
    #Case 1 is launched from a startup script, to save the session info
    #Case 2 loads the session info to prompt the user for powering down
    case $1 in
    1)
        echo DISPLAY=$DISPLAY > /tmp/gnome-session
        echo SESSION_MANAGER=$SESSION_MANAGER >> /tmp/gnome-session
        echo XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR >> /tmp/gnome-session
    ;;
    2)
        gnome_session_user=$(ps -o command,user -u gdm,root -N | grep gnome-session | awk '{print $2}')
        export $(cat /tmp/gnome-session)
        sudo -E -u $gnome_session_user /home/user/.scripts/screenoff.sh
    esac

Make it executable `chmod +x /etc/acpi/screenoff.sh`

Newt make the capture of the ENV vars:

`~/.config/autostart/screen.desktop`

     [Desktop Entry]
     Name=SessionSaver
     GenericName=Session Startup Saver
     Exec=/etc/acpi/screenoff.sh 1
     Terminal=false
     Type=Application
     X-GNOME-Autostart-enabled=true

Don't forget to start it once by hand.

Now edit `/etc/acpi/handler.sh`

Search for the Line Power Button stuff in the script. Beneath the logger line add:
    
    logger 'Powerbutton.....`
    /etc/acpi/screenoff.sh 2

Save and you are set:-)

To make this work, restart the acpi deamon and gather the ENV vars:

`sudo systemctl restart acpid`  

`/etc/acpid/screenoff.sh 1`

Download the local screenoff.sh file and put it here(also make it executeable):

`.config/autostart/screenoff.sh`

This will deactivate the touch and the Windows button with the screen and after some time will shutdown the device.

## Optimizations

Some time for some optimazations :-)

### Install guake

`pcman -Syu guake`

After install you can change the options with `guake -p`

Recommends:
- Dark Dektop Theme
- Alight left, 140 px offset
- Autostart at login
- Quick open with geany

### Change system Language to English and leave the Input to German keyboard.

`nano /etc/locale.gen` uncomment

`en_US.UTF-8 UTF8`

`en_DK.UTF-8 UTF8 # gives European Units and A4 Paper size`

`locale-gen`

Change in Gnome Settings.

### Deactivate Gnome file tracking
Saves a bit of RAM.

Just deactivate all the "Search" Options in the Gnome Settings.

### Better virtual keyboard

Install these shell extensions:

-> https://extensions.gnome.org/extension/993/slide-for-keyboard/  
-> https://extensions.gnome.org/extension/1024/caribou-resize-workspace/

Then do this in a terminal:

`gsettings set org.gnome.shell.keyboard keyboard-type tablet`

### Turn off keyboard lights

If you pess F2 on the keyboard you can turn of/dimm the light of the keyboard. Make sure Fn is NOT pressed.

### Install earlyoom

earlyoom checks the amount of available memory and (since version 0.5) free swap 10 times a second. If both are below 10%, it will kill the largest process. So you got a resonsive system, no matter what.

`pacaur -S earlyoom`  
`sudo systemctl enable earlyoom`  
`sudo systemctl start earlyoom`

### Install Chrome Tab suspender
Unload, park, suspend tabs to reduce memory footprint of chrome.  Set the timer to 5 minutes and activate auto reload :-)

-> https://chrome.google.com/webstore/detail/the-great-suspender/klbibkeccnjlkjkiokjodocebajanakg/related?hl=en

### Kill Gnome stuff to save RAM

Gnome lets run a lot of deamons who do use RAM. If you plan to use the surface as a second pc or not use evolution and social features at all. Consider to remove some of them for more RAM and a bit longer battery life:

First, mkdir a new folder in /usr/lib/gnome-settings-daemon/:  
`sudo mkdir /usr/lib/gnome-settings-daemon/backup/`

Second, mv all files you dont need into backup/ folder:  
`sudo mv -v /usr/lib/gnome-settings-daemon/gsd-print* /usr/lib/gnome-settings-daemon/backup`  
`sudo mv -v /usr/lib/gnome-settings-daemon/gsd-shar* /usr/lib/gnome-settings-daemon/backup`

__Do the same for Evolution (100MB of RAM):__

First, mkdir a backup directory:  
`sudo mkdir /usr/lib/evolution/backup/`  
  
Second, mv them all:  
` sudo mv /usr/lib/evolution/evolution-* /usr/lib/evolution/backup/`  

First, mkdir a backup directory:  

`sudo mkdir /usr/lib/evolution-data-server/backup/`  

Second, mv them all:  

` sudo mv /usr/lib/evolution-data-server/evolution-* /usr/lib/evolution-data-server/backup/`  

__PS:__ Gnome seems to have still some memory leaks. It grows to 1.8 GB of RAM after like 5 hours of use.

### Install WRITE from Stylus Labs:

Write is a better xournal :-)

Download it from here -> http://www.styluslabs.com/download/

Unpack and copy to the right place:

    tar xf write*.tar.gz`
    cp write209/Write/Write /usr/local/bin
    chmod +x /usr/local/bin/Write

### Use Dark Desktop Theme

Dark Theme helps reduce Battery drain and it looks good. Use Gnome-Tweaks to set it.

### Disable Workspaces 

To get more space and a tidyer "Activities" you can disable the worspaces in Gnome-Tweaks if you not need them.

If you need them on the other hand, make sure you use: -> https://extensions.gnome.org/extension/503/always-zoom-workspaces/

## Disable Title-Bars

To make more room you can use this: -> https://extensions.gnome.org/extension/1267/no-title-bar/
