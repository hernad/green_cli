#!/bin/bash

ISO_PATH=http://dl.bintray.com/hernad/greenbox
#ISO_PATH=http://download.bring.out.ba
#ISO_PATH=http://212.47.245.111
ISO_PATH=http://45.76.84.237

if [ -z "$2" ]; then
  echo "usage $0 <SERVER_NAME> <GREENBOX_VERSION>"
  exit 1
fi

SERVER_NAME=${1:greenbox-scw-0}
GREENBOX_VER=${2:-4.5.10}

#REGION=ams1
#SERVER_IP=51.15.62.134

echo "server_name=$SERVER_NAME, greenbox_ver=$GREENBOX_VER"

function server_restart() {

#RESTART_METHOD="ssh"
#RESTART_METHOD="scw"

SERVER_STOPPING=`scw ps -a | grep "stopping.*$SERVER_NAME" | awk '{print $1}'`
while [ ! -z "$SERVER_STOPPING" ] ; do
     echo "$SERVER_NAME is in stopping process ... waiting 30sec ..."
     sleep 30
     SERVER_STOPPING=`scw ps -a | grep "stopping.*$SERVER_NAME" | awk '{print $1}'`
done


SERVER_ID=`scw ps | grep "running.*$SERVER_NAME" | awk '{print $1}'`
if [ -z "$SERVER_ID" ] ; then
  SERVER_ID=`scw ps -a | grep "$SERVER_NAME" | awk '{print $1}'`
  echo starting $SERVER_ID
  scw start $SERVER_ID
else
     echo restarting $SERVER_ID
     scw restart $SERVER_ID
fi

}


server_restart
echo "SERVER_ID=$SERVER_ID"

./scw-ipxe-start.expect $SERVER_ID "initrd ${ISO_PATH}/greenbox-${GREENBOX_VER}.iso" "chain http://boot.salstar.sk/memdisk iso raw"

