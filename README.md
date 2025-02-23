cgit containerized
==================

Introduction
------------

To build this project, can be set some variables. To check which ones,
just open the *Makefile* and see the variables section.

How to build
------------

After customizing the variables, to build the image, just execute:

```
$ make build
```

### Make targets

- `configs` --- Generates Dockerfile and config files.
- `build` --- Generates the Dockerfile and lanch the image's build.
- `rm-image` --- Removes the image from the system.
- `clean` --- Removes the generates files, except for the image from system.
- `run` --- Run (creates) the container.

How to run the container
------------------------

This is the comamnd used to run the container:

```
podman run -p <port>:80 \
	--name <name> \
	-v <volume-or-path>:/var/www/cgit:Z \
	cgit
```

For example, using a directory to store repositories:

```
podman run -p 2080:80 \
	--name cgit \
	-v $HOME/git-repos:/var/www/cgit:Z \
	cgit
```

or, better, a volume:

```
podman run -p 2080:80 \
	--name cgit \
	-v cgit-data:/var/www/cgit:Z \
	cgit
```

How to create a new repository
------------------------------

```
podman exec -it cgit create-repository.sh
```

Contributing
------------

Versioning this project follow these rules. Before releasing the stable
version, the version must be set to *alpha*, *beta*, *rc* and, at the end of
the cicle, the version. For example, to release the version 0.0.0, must be
follow this schema:

1. 0.0.0-alpha.0
1. 0.0.0-alpha.1
1. 0.0.0-beta.0
1. 0.0.0-beta.1
1. 0.0.0-rc.0
1. 0.0.0-rc.1
1. 0.0.0
