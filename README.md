# Set of scripts to automatically build minc-tollkit packages

## Introduction
These scripts are using [docker](https://www.docker.com/) to automatically
build [minc-toolkit](https://github.com/BIC-MNI/minc-toolkit) and [minc-toolkit-v2](https://github.com/BIC-MNI/minc-toolkit-v2) binary packages.


## Installing
Setup docker using instructions from https://docs.docker.com/get-started/ ,
make sure that user that will be using these scripts is a member of `docker`
group, or use `sudo` to execute build scripts.
After docker is successfully installed, execute `prepare_docker_build_images.sh` script -
it will prepare docker images needed for building all versions of minc-toolkit.
**WARNING** it will download quite a lot of stuff from docker.
Currently following systems are supported:

* Centos 6.9 , 64bit
* Centos 7.3 , 64bit
* Fedora 23  , 64bit
* Fedora 25  , 64bit
* Debian 8   , 64bit
* Ubuntu 14.04, 32&64bit
* Ubuntu 16.04, 32&64bit

If you need to build only for specific system, you can manually initialize docker image needed by running `docker build -t minc-build_<SYSTEM> build_<SYSTEM>`.
For example for ubuntu-16.04 64bit: `docker build -t minc-build_ubuntu_16.04_x64 build_ubuntu_16.04_x64`

## Building individual packages
All resulting packages will be placed in `packages` directory.

To build package for particular system execute:

* For minc-toolkit `./build_v1.sh    minc-build_<SYSTEM> <RPM|DEB>`
* For minc-toolkit-v2 `./build_v2.sh minc-build_<SYSTEM> <RPM|DEB>`
* For data packages: `./build_data.sh minc-build_<SYSTEM> <RPM|DEB>`

## Building all packages
For building all supported binary packages: `build_all.sh`.
