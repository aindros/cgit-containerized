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
OCI       = podman
IMAGENAME = cgit
VERSION   = 0.0.0-alpha.0
WORKDIR   =

build: Dockerfile
	${OCI} build -t ${IMAGENAME}:latest -t ${IMAGENAME}:${VERSION} .

Dockerfile:
	@WORKDIR=${WORKDIR} scripts/create-dockerfile.sh

clean:
	@rm -f Dockerfile

help:
	@grep -oE '^[a-zA-Z0-9].*:' Makefile | sed -E 's/:$$//g'

rm-image:
	podman rmi ${IMAGENAME}

