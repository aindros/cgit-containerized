#!/bin/sh

filegroups=$WORKDIR/.groups

if [ -z $1 ]; then
	echo "Usage: $0 <groupname>"
	exit 1
fi

if [ ! -f $filegroups ]; then
    touch $filegroups
fi

if [ ! -z "$(grep -oE "^$1:" $filegroups | awk '{print $1}')" ]; then
	echo "Group '$1' exists."
	exit
fi

echo "$1:" >> $filegroups
echo "Group '$1' created."
