
cgit containerized
==================

How to create the Dockerfile
----------------------------

```
make Dockerfile
```

How to build the image
----------------------

To build the image:
```
$ make build
```
or:
```
$ podman build -t cgit .
```
`cgit` is the image's name, it can be replaced with any other name.

