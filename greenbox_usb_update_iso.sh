#!/bin/bash

# https://github.com/bjasko/docker_scripts/blob/master/greenbox_usb_update


if [ $# -lt 1 ]
then
    echo "argumenti su:   ./greenbox_usb_update  [GREENBOX_VER]"
    echo " npr:   ./greenbox_usb_create 3.7.2"
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
    echo "Pokreni kao root" 1>&2
    exit 1
fi

GREENBOX_VERSION=$1
GREEN_ISO=http://download.bring.out.ba/greenbox-${GREENBOX_VERSION}.iso
GREEN_CFG=/media/syslinux.cfg
DEF_BOOT=`cat $GREEN_CFG | grep "^default boot" | awk '{print $2}'`
ISO_MNT=/tmp/$1
BOOT_PATH=/media/boot


if wget --spider $GREEN_ISO 2>/dev/null; then
    echo "update postoji, nastavljam"
    cd  /tmp && wget -q $GREEN_ISO
    
else
    echo "update iso ne postoji"
    exit
fi


echo "defaultni boot je $DEF_BOOT"

if [ -d "$ISO_MNT" ]; then
    echo "ISO mountpoint $ISO_MNT postoji, provjeritte, prekidam..... "
    exit
else
    mkdir $ISO_MNT
    mount -o loop /tmp/greenbox-$1.iso  $ISO_MNT
fi

if [ -d "$BOOT_PATH/$1" ]; then
    echo "$BOOT_PATH/$1 već postoji, provjerite......"
    exit
else
    mkdir $BOOT_PATH/$1
    cp $ISO_MNT/boot/initrd.img  $BOOT_PATH/$1
    cp $ISO_MNT/boot/vmlinuz64 $BOOT_PATH/$1
    umount $ISO_MNT
    rm -rf $ISO_MNT
fi


if [ "$DEF_BOOT" == "boot$1" ]; then
    echo "$DEF_BOOT je već defaultni boot ...prekidam"
    exit
else
    echo "label boot$1" >> $GREEN_CFG
    echo "menu label greenbox-$1" >> $GREEN_CFG
    echo "kernel /boot/$1/vmlinuz64"  >> $GREEN_CFG
    echo "append initrd=/boot/$1/initrd.img loglevel=3 dockerpwd=test01 nozswap nofstab tz=CET-1CEST,M3.5.0,M10.5.0/3 noembed nomodeset norestore waitusb=10 LABEL=GREEN_HDD console=ttyS0,115200n8"  >> $GREEN_CFG
    echo ""  >> $GREEN_CFG
fi

if  [ "$DEF_BOOT" == "" ]; then
    echo "$DEF_BOOT je prazan dodajem ga"
    sed -i '3idefault boot'"$1"'\'  $GREEN_CFG
    sync
else
    sed -i -e 's/default '"$DEF_BOOT"'/default boot'"$1"'/' $GREEN_CFG
    sync
fi
