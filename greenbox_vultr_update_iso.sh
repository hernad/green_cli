#!/bin/bash

WAIT_ISO_UPLOAD=60
DOWNLOAD_URL=http://download.bring.out.ba

echo VULTR_API_KEY=$VULTR_API_KEY


if [ $# -lt 2 ] ; then
  echo "Usage: $0 <SERVER_NAME> <GREENBOX_VERSION>"
  exit 1
fi

if [ -z "$VULTR_API_KEY" ] ; then
  echo "VULTR_API_KEY not defined. STOP"
  exit 1
fi

if ! which vultr ; then
  echo "vultr command not found. STOP"
  exit 1
fi


CMD="curl -H 'API-Key: $VULTR_API_KEY' https://api.vultr.com/v1/iso/list"
echo $CMD
eval $CMD

SERVER_NAME=${1:-greenbox-0}
GREENBOX_VERSION=${2:-4.5.9}

VULTR_SERVER_ID=`vultr server list | grep $SERVER_NAME | awk '{print $1}'`
if [ -z "$VULTR_SERVER_ID" ] ; then
  echo "vultr server $SERVER_NAME not found ?! STOP"
  exit 1
fi


VULTR_ISO_ID=`vultr iso | grep greenbox-${GREENBOX_VERSION}.iso | awk '{print $1}'`
if [ -n "$VULTR_ISO_ID" ] ; then
  echo "GREENBOX_VERSION=$GREENBOX_VERSION iso installed"
else
  echo "installing $GREENBOX_VERSION iso ..."
  echo -e
  CMD="curl -XPOST -H \"API-Key: $VULTR_API_KEY\" https://api.vultr.com/v1/iso/create_from_url --data \"url=${DOWNLOAD_URL}/greenbox-${GREENBOX_VERSION}.iso\""
  echo $CMD
  eval $CMD
  echo "waiting $WAIT_ISO_UPLOAD sec ..."
  sleep $WAIT_ISO_UPLOAD
fi

#output:
#{"ISOID":275309}


while [ -z "$VULTR_ISO_ID" ] ; do
 echo "waiting 10sec for greenbox $GREENBOX_VERSION iso to be installed ..."
 sleep 10
 VULTR_ISO_ID=`vultr iso | grep greenbox-${GREENBOX_VERSION}.iso | awk '{print $1}'`
done


echo "iso_id=$VULTR_ISO_ID, server_id=$VULTR_SERVER_ID"

echo attaching iso $VULTR_ISO_ID to server $VULTR_SERVER_ID, then restart
vultr server iso attach $VULTR_SERVER_ID \
   --iso=$VULTR_ISO_ID


