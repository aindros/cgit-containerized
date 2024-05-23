#!/bin/sh

urldecode()
{
	# urldecode <string>
	echo -n $1 \
		| sed 's/%40/\@/g' \
		| sed 's|%2F|\\/|g' \
		| sed 's/+/ /g'
}

for i in `echo $QUERY_STRING | sed 's/\&/ /g'`; do
	i=`urldecode $i`
	case $i in
		repositoryName=*)          repositoryName=${i#*=} ;;
		repositoryDescription=*)   repositoryDescription=${i#*=} ;;
		repositoryOwnerFullName=*) repositoryOwnerFullName=${i#*=} ;;
		repositoryOwnerEmail=*)    repositoryOwnerEmail=${i#*=} ;;
		repositoryDirectory=*)     repositoryDirectory=${i#*=} ;;
		repositoryHide=*)          repositoryHide=${i#*=} ;;
	esac
done

if [ ! -z "$repositoryName" ]; then
	cd /cgit-repositories \
			&& git init --bare "$repositoryName".git > /dev/null 2> /dev/null \
			&& cd - > /dev/null

	if [ $SERVER_PROTOCOL = 'HTTP/1.1' ]; then
		url='http://'
	else
		url='https://'
	fi

	url=$url$SERVER_NAME

	if [ $SERVER_PORT -ne 80 ]; then
		url=$url:$SERVER_PORT
	fi

	echo "Location: $url/$repositoryName.git"
	echo
	exit
fi

echo 'Content-type: text/html'
echo ''
cat template.html \
	| sed "s/\${repositoryName}/$repositoryName/g" \
	| sed "s/\${repositoryDescription}/$repositoryDescription/g" \
	| sed "s/\${repositoryOwnerFullName}/$repositoryOwnerFullName/g" \
	| sed "s/\${repositoryOwnerEmail}/$repositoryOwnerEmail/g" \
	| sed "s/\${repositoryDirectory}/$repositoryDirectory/g" \
	| sed "s/\${repositoryHide}/$repositoryHide/g"

