#! /bin/bash

# iterate over minc-toolkit-v1 and -2
for v in v1 v2;do

# build RPM-based packages
for m in build_centos_7.3_x64 build_fedora_25_x64;do
./build_${v}.sh minc-$m RPM
done

# build DEB-based packages
for m in build_debian_8_x64 build_ubuntu_14.04_x64 build_ubuntu_16.04_x64 build_ubuntu_16.04_x32 build_ubuntu_14.04_x32;do
./build_${v}.sh minc-$m DEB
done

done

# building RPM data package
./build_data.sh minc-build_centos_7.3_x64 RPM

# building DEB data package
./build_data.sh minc-build_ubuntu_16.04_x64 DEB
