#!/bin/sh

CONFDIR=$(dirname $(realpath $0))/../config
A2CONFIG=$CONFDIR/000-default.conf
CGITRC=$CONFDIR/cgitrc

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


cat << EOF > $CGITRC
#
# cgit config
# see cgitrc(5) for details

enable-git-config=1
#snapshots=tar.gz tar.bz2 zip
snapshots=tar.gz zip

readme=:README.md
readme=:README

about-filter=/usr/lib/cgit/filters/about-formatting.sh

css=/cgit-css/cgit.css
logo=/cgit-css/cgit.png

#source-filter=/usr/lib/cgit/filters/syntax-highlighting-custom.sh
#source-filter=/usr/lib/cgit/filters/syntax-highlighting-custom.sh

# https://lists.zx2c4.com/pipermail/cgit/2019-July/004387.html
section-from-path=1

# if you do not want that webcrawler (like google) index your site
robots=noindex, nofollow

# https://lists.zx2c4.com/pipermail/cgit/2014-March/002036.html
email-filter=lua:/usr/lib/cgit/filters/email-libravatar-korg.lua

source-filter=/usr/lib/cgit/filters/syntax-highlighting.sh

#scan-path=$WORKDIR

# To update the reposotories lit:
# /usr/lib/cgit/cgit.cgi --scan-tree=$WORKDIR/ > /etc/cgit-repos
#include=/etc/cgit-repos

#virtual-root=/repos/

include=$WORKDIR/cgit-repos

EOF
