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







