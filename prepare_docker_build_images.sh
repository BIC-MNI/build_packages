#! /bin/bash


# prepare all docker images
for m in build_centos_* \
            build_debian_* \
            build_fedora_* \
            build_ubuntu_* \
do
docker build -t minc-${m} $m
done

