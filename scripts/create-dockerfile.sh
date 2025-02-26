#!/bin/sh

DOCKERFILE=$(dirname $(realpath $0))/../Dockerfile

[ -z $WORKDIR ] && WORKDIR=/var/www/cgit

cat << EOF > $DOCKERFILE
#-
# BSD 2-Clause License
#
# Copyright (c) 2024, Alessandro Iezzi
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM debian:latest
MAINTAINER Alessandro Iezzi <aiezzi@alessandroiezzi.it>

# Make the update of package indexes and install: apache2, cgit, git and
# highlight. Apache is the web server, exposed to the port 80; cgit is the web
# UI for git and highlight is a tool to get the syntax highlight (not yet
# configured in this version of cgit-containerized).
RUN apt-get update
RUN apt-get install -y apache2 cgit git highlight nano

# Needed by /usr/lib/cgit/filters/email-libravatar.lua
RUN apt-get install -y lua-luaossl

# Prepare cgit
#
# Replace /etc/cgitrc with the one in config directory and create the directory
# for the git repositories.
ADD config/cgitrc /etc/
RUN mkdir -p $WORKDIR
RUN chmod 777 $WORKDIR

# Create a directory for shell scripts
RUN mkdir -p $WORKDIR/bin
ENV PATH=\$PATH:$WORKDIR/bin
ENV WORKDIR=$WORKDIR

# Add scripts to manage cgit repositories
COPY scripts/create-repository.sh /usr/local/bin/create-repository.sh
COPY scripts/create-group.sh /usr/local/bin/create-group.sh

# Prepare Apache Web Server
#
# First of, disable the default virtual host and replace it with the one in
# config directory. Then, add the configuration for cgit.
RUN a2dissite 000-default
ADD config/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD config/cgit.conf /etc/apache2/conf-available/

# Enable authz_groupfile used in the virtual host.
RUN a2enmod authz_groupfile

# Enable the cgit configuration
RUN a2enconf cgit
RUN a2enmod cgid

# Finally, enable the virtual host.
RUN a2ensite 000-default

# Application to create git repositories
ADD html /var/www/html

EXPOSE 80

WORKDIR $WORKDIR

ENTRYPOINT service apache2 start && bash
EOF
