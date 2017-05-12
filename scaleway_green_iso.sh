#!/bin/bash

ISO_PATH=http://dl.bintray.com/hernad/greenbox
ISO_PATH=http://download.bring.out.ba
#ISO_PATH=http://212.47.245.111
ISO_PATH=http://45.76.84.237

SERVER_TYPE=C
GREENBOX_VER=4.5.9
SERVER_NAME=greenbox-scw-0
#REGION=ams1
SERVER_IP=51.15.62.134

function server_restart() {

if [ "$1" == "ssh" ]
then
  RESTART_METHOD="ssh"
else
  RESTART_METHOD="scw"
fi

SERVER_STOPPING=`scw ps -a | grep "stopping.*$SERVER_NAME" | awk '{print $1}'`
while [ ! -z "$SERVER_STOPPING" ] ; do
     echo "$SERVER_NAME is in stopping process ... waiting 30sec ..."
     sleep 30
     SERVER_STOPPING=`scw ps -a | grep "stopping.*$SERVER_NAME" | awk '{print $1}'`
done


SERVER_ID=`scw ps | grep "running.*$SERVER_NAME" | awk '{print $1}'`
if [ -z "$SERVER_ID" ]
then
  SERVER_ID=`scw ps -a | grep "$SERVER_NAME" | awk '{print $1}'`
  echo starting $SERVER_ID
  scw start $SERVER_ID
else
  if [ "$RESTART_METHOD" == "ssh" ] ; then
     echo "ssh restart root@$SERVER_IP reboot -f"
     ssh root@$SERVER_IP reboot -f
  else
     echo restarting $SERVER_ID
     scw restart $SERVER_ID
  fi
fi

}

if [ "$REGION" == "ams1" ] ; then
  server_restart ssh
else 
  server_restart 
fi


echo "SERVER_ID=$SERVER_ID"

./scw-ipxe-start.expect $SERVER_ID "initrd ${ISO_PATH}/greenbox-${GREENBOX_VER}.iso" "chain http://boot.salstar.sk/memdisk iso raw"

