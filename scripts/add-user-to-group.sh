#!/bin/sh

grpfile=$WORKDIR/.groups

if [ -z $1 ]; then
	echo "Usage: $0 <username>"
	exit 1
fi

# Listing groups
grplist=$(cat $grpfile | sed 's/:.*//g')
for i in $(echo $grplist); do
	echo $i
done

echo -n 'Choose one or more groups: '
read usergroups

for ug in $(echo $usergroups); do
	if [ -z "$(echo $grplist | grep -w $ug)" ]; then
		echo "'$ug' doesn't exist. Ignoring."
	else
		line=$(grep -E "^$ug:" $grpfile)
		if [ -z "$(echo $line | grep -w $1)" ]; then
			# if user is not part of that group
			sed -i'' -E "s/$line/$line $1/g" $grpfile
			echo "'$1' added to '$ug' group."
		else
			echo "'$1' already belongs to '$ug' group."
		fi
	fi
done
