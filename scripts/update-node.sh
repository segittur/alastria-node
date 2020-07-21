#!/bin/bash
set -u
set -e
TMPFILE="/tmp/$(basename $0).$$.tmp"
tmpfile=$(mktemp /tmp/updatePerm.XXXXXX)
NODE_TYPE="$1"
DESTDIR="$HOME/alastria/data/"
DATADIR="$HOME/alastria-node/data/"

mkdir -p $HOME/alastria/data/

echo "[" > $TMPFILE

if [ "$NODE_TYPE" == "bootnode" ]; then
     cat $DATADIR/boot-nodes.json $DATADIR/validator-nodes.json $DATADIR/regular-nodes.json >> $TMPFILE
fi
if [ "$NODE_TYPE" == "validator" ]; then
     cat $DATADIR/boot-nodes.json $DATADIR/validator-nodes.json >> $TMPFILE
fi
if [ "$NODE_TYPE" == "general" ]; then
     cat $DATADIR/boot-nodes.json >> $TMPFILE
fi
cat $TMPFILE | sed '$s/,$//' > $tmpfile
echo "]" >> $tmpfile

cat $tmpfile > $DESTDIR/static-nodes.json
cat $tmpfile > $DESTDIR/permissioned-nodes.json

rm $TMPFILE
rm $tmpfile

# gracefull restart for geth
./stop.sh
./start.sh

set +u
set +e