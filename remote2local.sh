#!/bin/bash

#make sure that you should make a private key and a public key by using ssh-keygen command,
#and add the public key into authorized_keys file in ~/.ssh directory of remote host 
#list.exclude file have to include filenames with absolute path and directories ended with "/"
# set up the environment
NOW=$(date +"%Y-%m-%d")
EXCLUDE="/the/path/of/directory/list.exclude"
RSYNC_DIR="/the/path/of/directory/rsync_dir"

# point the log file out
OUTPUT="/scguser/remote2local.log"
exec 3>> $OUTPUT

echo "==============================================" >&3
echo "rsyn Date : ${NOW} " >&3
echo "==============================================" >&3

for entry in "$RSYNC_DIR"/*
do
  if [ -d "$entry" ] && [ $(grep -xc ${entry}/ $EXCLUDE) -eq 0 ]
  then
    echo "----------------------------------------------" >&3
    echo "** rsync directory : $entry " >&3
    echo "----------------------------------------------" >&3
    rsync -ptgouv --delete -r --exclude-from=${EXCLUDE} -e ssh user_name@hostname:${entry}/ $entry >&3
  fi
done

exec 3>&-
