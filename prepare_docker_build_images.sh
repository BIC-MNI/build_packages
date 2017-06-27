#! /bin/bash


# prepare all docker images
for m in build_centos_7.3_x64 \
            build_debian_8_x64 \
            build_fedora_25_x64 \
            build_ubuntu_14.04_x32 \
            build_ubuntu_14.04_x64 \
            build_ubuntu_16.04_x32 \
            build_ubuntu_16.04_x64 ;do
docker build -t minc-${m} $m
done

