#!/bin/sh

A2CONFIG=$(dirname $(realpath $0))/../config/000-default.conf

[ -z $WORKDIR ] && WORKDIR=/var/www/cgit

cat << EOF > $A2CONFIG
<VirtualHost *:80>
#	ServerName git.alessandroiezzi.it
	DocumentRoot "$WORKDIR"

	SetEnv GIT_PROJECT_ROOT $WORKDIR
	SetEnv GIT_HTTP_EXPORT_ALL

	ScriptAliasMatch \\
		"(?x)^/(.*/(HEAD | \\
						info/refs | \\
						objects/(info/[^/]+ | \\
						         [0-9a-f]{2}/[0-9a-f]{38} | \\
						         pack/pack-[0-9a-f]{40}\.(pack|idx)) | \\
						git-(upload|receive)-pack))$" \\
		/usr/lib/git-core/git-http-backend/\$1

	<LocationMatch "^/.*git-receive-pack$">
		AuthType Basic
		AuthName "Git Access"
		AuthUserFile $WORKDIR/.passwd
		AuthGroupFile $WORKDIR/.groups
		Require group admin
	</LocationMatch>

	<LocationMatch "^/">
	</LocationMatch>

	<LocationMatch "^/.*\.git">
	</LocationMatch>

	<Directory /usr/lib/git-core>
		Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
		AllowOverride None
		Require all granted
	</Directory>

	<Directory "/usr/lib/cgit/">
		AllowOverride None
		Options +ExecCGI
		DirectoryIndex cgit.cgi
		AddHandler cgi-script .cgi

		Require method GET OPTIONS PROPFIND
	</Directory>

	<Directory "/var/www/html">
		AllowOverride None
		Options +ExecCGI
		DirectoryIndex create.sh
		AddHandler cgi-script .sh
	</Directory>

	# this part is the magic
	Alias /cgit-css  "/usr/share/cgit/"
	Alias /create    "/var/www/html/"
	Alias /bootstrap "/var/www/html/bootstrap"
	Alias / /usr/lib/cgit/cgit.cgi/
</VirtualHost>

EOF
