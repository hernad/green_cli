#!/bin/bash

G7_SERVER=$1

RESTART=no
if [ "$2" == "--restart" ]; then
   RESTART=yes
fi

GREEN_ISO=greenbox-${GREENBOX_VERSION}.iso

if [ ! -f $GREEN_ISO ] ; then
   curl -LO http://download.bring.out.ba/$GREEN_ISO
fi

G7_USERPROFILE=`ssh greenbox@${G7_SERVER} "source /c/G7_bringout/g7_common.sh --silent; set | grep ^USERPROFILE="`

DOCKER_MACHINE_DIR="`echo $G7_USERPROFILE | awk -F= '{print $2}'`/.docker/machine/machines/greenbox"

echo $DOCKER_MACHINE_DIR

ssh greenbox@${G7_SERVER} ls -l "$DOCKER_MACHINE_DIR"
ssh greenbox@${G7_SERVER} cp "$DOCKER_MACHINE_DIR/boot2docker.iso" "$DOCKER_MACHINE_DIR/boot2docker.iso.orig"

ssh greenbox@${G7_SERVER} VBoxManage controlvm greenbox poweroff

scp $GREEN_ISO greenbox@${G7_SERVER}:"${DOCKER_MACHINE_DIR}"/boot2docker.iso

ssh greenbox@${G7_SERVER} ls -l "$DOCKER_MACHINE_DIR"

if [ $RESTART == "yes" ] ; then
  ssh greenbox@${G7_SERVER} restart_windows
fi

#/c/Users/greenbox/.docker/machine/machines/greenbox/

