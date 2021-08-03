# Linux-x86_64 SDK for Mach Engine

This repository contains native system binary files required to build [Mach Engine](https://github.com/hexops/mach) for Linux (x86_64), from any host OS.

In specific, it contains a minimal set of Ubuntu packages.

## LICENSE

All files in this SDK are permissively licensed (MIT, BSD, Apache, X, and SGI licenses) **except** for the mesa GL development library, of which portions are GPL licensed - and whose file list you can find here:

https://packages.ubuntu.com/bionic/amd64/mesa-common-dev/filelist

Mach only uses the GL development headers from the mesa library, which are permissively (not GPL) licensed.

You can find the license information in the standard Linux locations, e.g.:

```
$ find root | grep copyright
root/usr/share/doc/libxdmcp-dev/copyright
root/usr/share/doc/x11proto-dev/copyright
root/usr/share/doc/libxrandr-dev/copyright
root/usr/share/doc/libxcb1-dev/copyright
root/usr/share/doc/libxau-dev/copyright
root/usr/share/doc/libxext-dev/copyright
root/usr/share/doc/mesa-common-dev/copyright
root/usr/share/doc/libxcb1/copyright
root/usr/share/doc/libxinerama-dev/copyright
root/usr/share/doc/libxcursor-dev/copyright
root/usr/share/doc/libxi-dev/copyright
root/usr/share/doc/libx11-6/copyright
root/usr/share/doc/libvulkan-dev/copyright
root/usr/share/doc/libx11-dev/copyright
root/usr/share/doc/libxfixes-dev/copyright
root/usr/share/doc/libxrender-dev/copyright
```
