#!/bin/sh

if [ ! -z "$(git tag -l | grep $1)" ]; then
    echo Tag v$1 exists.
    exit
fi

echo git commit -m '"cgit-containerized '$1'"'
echo git tag -a v$1 -m '"Version '$1'"'
