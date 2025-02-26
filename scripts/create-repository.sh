#!/bin/sh

# WORKDIR - is defined by Dockerfile

repositoryName()
{
	echo -n "Repository name: "
	read REPONAME
}

repositoryDescription()
{
	echo -n "Repository description: "
	read DESCRIPTION
}

repositoryOwnerName()
{
	echo -n "Repository owner full name: "
	read OWNERNAME
}

repositoryOwnerMail()
{
	echo -n "Repository owner email: "
	read OWNEREMAIL

	if [ -z $OWNEREMAIL ]; then
		OWNER="$OWNERNAME"
	else
		OWNER="$OWNERNAME <$OWNEREMAIL>"
	fi
}

repositoryRoot()
{
	echo -n "Enter organization/directory name (leave empty for root): "
	read directory
}

repositoryHide()
{
	echo -n "Do you want to hide this new repository? [n]: "
	read hide
}

initData()
{
	repositoryName
	repositoryDescription
	repositoryOwnerName
	repositoryOwnerMail
	repositoryRoot
	repositoryHide
}

createRepository()
{
	if [ ! -z $directory ]; then
		mkdir -p $directory
		chown -R www-data:www-data $directory
		REPONAME=$directory/$REPONAME
	fi

	echo 'Creating the repository '$REPONAME

	git init --bare $REPONAME.git

	echo $DESCRIPTION > $REPONAME.git/description

cat << EOF >> $REPONAME.git/config
[http]
	receivepack = true

[gitweb]
	owner = $OWNER
EOF

	chown -R www-data:www-data $REPONAME.git
}

cgitConfigRepository()
{
	if [ -z "$directory" ]; then
		CGITREPOS=$WORKDIR/cgit-repos-root
	else
		CGITREPOS=$WORKDIR/cgit-repos-$(echo $directory | sed 's/\/.*//g')
	fi

	touch $WORKDIR/cgit-repos
	if [ -z "$(grep -E "^include=$CGITREPOS" $WORKDIR/cgit-repos)" ]; then
		echo "include=$CGITREPOS" >> $WORKDIR/cgit-repos
	fi

	if [ ! -f $CGITREPOS ]; then
		touch $CGITREPOS
	else
		# Leave a space between repository configurations
		echo "" >> $CGITREPOS
	fi

	if [ "$hide" = "y" ]; then
		hide=1
	else
		hide=0
	fi

cat << EOF >> $CGITREPOS
repo.url=$REPONAME.git
repo.name=$REPONAME.git
repo.path=$WORKDIR/$REPONAME.git/
repo.owner=$OWNER
repo.desc=$DESCRIPTION
repo.section=$directory
repo.enable-commit-graph=0
repo.enable-log-filecount=0
repo.enable-log-linecount=0
repo.enable-remote-branches=0
repo.enable-subject-links=0
repo.enable-html-serving=0
repo.hide=$hide
repo.ignore=0
EOF
}

initData
createRepository
cgitConfigRepository
