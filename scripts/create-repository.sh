#!/bin/sh

echo -n "Repository name: "
read reponame

echo -n "Repository description: "
read description

echo -n "Repository owner full name: "
read ownername

echo -n "Repository owner email: "
read owneremail

echo -n "Enter organization/directory name (leave empty for root): "
read directory

echo -n "Do you want to hide this new repository? [n]: "
read hide

if [ ! -z $directory ]; then
    mkdir -p $directory
    chown -R www-data:www-data $directory
    reponame=$directory/$reponame
fi

if [ "$hide" = "y" ]; then
    hide=1
else
    hide=0
fi

git init --bare $reponame.git

descrf=$reponame.git/description
configf=$reponame.git/config

echo $description > $descrf

echo "[http]" >> $configf
echo "        receivepack = true" >> $configf
echo "" >> $configf
echo "[gitweb]" >> $configf

if [ -z $owneremail ]; then
    echo "        owner = $ownername" >> $configf
else
    echo "        owner = $ownername <$owneremail>" >> $configf
fi

chown -R www-data:www-data $reponame.git
