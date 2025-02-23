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

- `Dockerfile` --- Generates only Dockerfile.
- `build` --- Generates the Dockerfile and lanch the image's build.
- `rm-image` --- Removes the image from the system.
- `clean` --- Removes the generates files, except for the image from system.

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
podman run -p 6080:80 \
	--name cgit \
	-v $HOME/git-repos:/var/www/cgit:Z \
	cgit
```

or, better, a volume:

```
podman run -p 6080:80 \
	--name cgit \
	-v cgit-data:/var/www/cgit:Z \
	cgit
```





