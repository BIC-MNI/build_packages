#! /bin/bash


export PARALLEL=2

v=v2

# build RPM-based packages
for m in centos_7.3_x64 ;do
./build_${v}_min.sh minc-build_$m RPM
done

# build DEB-based packages ubuntu_14.04_x64 ubuntu_16.04_x64
for m in ubuntu_16.04_x64 ;do
./build_${v}_min.sh minc-build_$m DEB
done

