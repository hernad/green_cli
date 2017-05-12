#!/bin/bash


if [ $# -lt 2 ] ; then
  echo usage ./$0 G7_HOST GREENBOX_VERSION [--restart]
  exit 1
fi

G7_HOST=$1
GREENBOX_VERSION=$2

RESTART=no
if [ "$3" == "--restart" ]; then
   RESTART=yes
fi

GREEN_ISO=greenbox-${GREENBOX_VERSION}.iso

if [ ! -f $GREEN_ISO ] ; then
   curl -LO http://download.bring.out.ba/$GREEN_ISO
fi

G7_USERPROFILE=`ssh greenbox@${G7_HOST} "source /c/G7_bringout/g7_common.sh --silent; set | grep ^USERPROFILE="`

DOCKER_MACHINE_DIR="`echo $G7_USERPROFILE | awk -F= '{print $2}'`/.docker/machine/machines/greenbox"

echo "docker_machine_dir=$DOCKER_MACHINE_DIR"


ssh greenbox@${G7_HOST} ls -l "$DOCKER_MACHINE_DIR"
ssh greenbox@${G7_HOST} cp "$DOCKER_MACHINE_DIR/boot2docker.iso" "$DOCKER_MACHINE_DIR/boot2docker.iso.orig"

ssh greenbox@${G7_HOST} VBoxManage controlvm greenbox poweroff

scp $GREEN_ISO greenbox@${G7_HOST}:"${DOCKER_MACHINE_DIR}"/boot2docker.iso

ssh greenbox@${G7_HOST} ls -l "$DOCKER_MACHINE_DIR"

if [ $RESTART == "yes" ] ; then
  ssh greenbox@${G7_HOST} restart_windows
fi

#/c/Users/greenbox/.docker/machine/machines/greenbox/

