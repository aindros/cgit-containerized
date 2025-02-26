#!/bin/sh

if [ ! -z "$(git tag -l | grep $1)" ]; then
    echo Tag v$1 exists.
    exit
fi

COMMIT_MESSAGE='"cgit-containerized '$1'"'
TAG=v$1
TAG_MESSAGE='"Version '$1'"'

echo 'Commit message: '$COMMIT_MESSAGE
echo 'Tag: '$TAG
echo 'Tag message: '$TAG_MESSAGE

echo
while [ "$answer" != 'y' ] && [ "$answer" != 'n' ]; do
	printf "Proceed? [y/n]: "
	read answer
done

if [ "$answer" = 'y' ]; then
	echo git commit -m $COMMIT_MESSAGE
	git commit -m "cgit-containerized $1"

	echo git tag -a $TAG -m $TAG_MESSAGE
	git tag -a $TAG -m $TAG_MESSAGE
fi
