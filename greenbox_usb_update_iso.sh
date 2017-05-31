#!/bin/bash

# https://github.com/bjasko/docker_scripts/blob/master/greenbox_usb_update


if [ $# -lt 3 ]
then
    echo "argumenti su:   $0 <HOST> <GREENBOX_VER> <CONSOLE> [--restart]"
    echo " npr:   $0 192.168.168.110 3.7.2 vga --restart"
    exit 1
fi

HOST=$1
GREENBOX_VER=$2
CONSOLE=$3

if [ "$4" == "--restart" ] || [ "$4" == "--reboot" ] ; then
  REBOOT=1
fi


echo start
SCRIPT=`ssh docker@$HOST  ls /usr/local/bin/greenbox_usb_update`

echo $SCRIPT

if [ -z "$SCRIPT" ] ; then
  echo "install greenbox_usb_update script on host" 
  scp greenbox_usb_update.script  docker@${HOST}:/tmp/greenbox_usb_update &&\
  ssh docker@${HOST} "sudo mv /tmp/greenbox_usb_update /usr/local/bin/ ; chmod +x /usr/local/bin/greenbox_usb_update"

#else
#  ssh docker@$HOST  cat /usr/local/bin/greenbox_usb_update

fi

CMD="sudo /usr/local/bin/greenbox_usb_update $GREENBOX_VER $CONSOLE"
echo $CMD
ssh docker@$HOST "$CMD" 
if [ $? != 0 ] ; then
  echo "error greenbox_usb_update on $HOST"
  exit 1
fi

if [ -n "$REBOOT" ] ; then
   echo "rebooting $HOST ..."
   ssh docker@$HOST "sudo reboot"
fi
