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

# Customize these variables as you prefer.
#   OCI       - is the container tool
#   IMAGENAME - is the name of the image
#   VERSION   - is the tag of the image
#   WORKDIR   - is the directory where the repositories are stored
#   VOLUME    - can be a volume or a directory where to store repositories
#   PORT      - the listening port for cgit container
#   RFLAGS    - flags to use to run the container
OCI       = podman
IMAGENAME = cgit
VERSION   = 0.0.0-beta.2
WORKDIR   = /var/www/cgit
VOLUME    = cgit-data
PORT      = 2080
RFLAGS    = -it --rm
HUB       = aindros

build: configs
	${OCI} build -t ${IMAGENAME}:latest -t ${IMAGENAME}:${VERSION} .

configs:
	@WORKDIR=${WORKDIR} scripts/create-dockerfile.sh
	@WORKDIR=${WORKDIR} scripts/create-configs.sh

clean:
	@rm -f Dockerfile
	@rm -f config/000-default.conf
	@rm -f config/cgitrc

help:
	@grep -oE '^[a-zA-Z0-9].*:' Makefile | sed -E 's/:$$//g'

rm-image:
	@${OCI} rmi `${OCI} images --format '{{.Repository}}:{{.Tag}}' | grep '${IMAGENAME}'`

run: build
	${OCI} run ${RFLAGS} \
		-p ${PORT}:80 \
		-v ${VOLUME}:${WORKDIR}:Z \
		--name cgit \
		${IMAGENAME}

tag-release:
	@scripts/tag-release.sh ${VERSION}
	${OCI} tag ${IMAGENAME}:latest ${HUB}/${IMAGENAME}:latest
	${OCI} tag ${IMAGENAME}:${VERSION} ${HUB}/${IMAGENAME}:${VERSION}
	${OCI} push ${HUB}/${IMAGENAME}:latest
	${OCI} push ${HUB}/${IMAGENAME}:${VERSION}
