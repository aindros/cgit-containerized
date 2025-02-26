#!/bin/sh

if [ -z $1 ]; then
	echo "Usage: $0 <username>"
	exit 1
fi

pwdfile=$WORKDIR/.passwd

if [ ! -f $pwdfile ]; then
	htpasswd -c $pwdfile $1
else
	htpasswd $pwdfile $1
fi
