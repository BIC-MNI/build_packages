#! /bin/bash

mkdir -p logs

# iterate over minc-toolkit-v1 and -2
for v in v1 v2;do

  # build RPM-based packages
  for m in centos_7.3_x64 fedora_23_x64 fedora_25_x64; do
    ./build_${v}.sh minc-build_$m RPM 2>&1 | tee logs/minc-build_${m}_${v}.log
  done

  # build DEB-based packages
  for m in debian_8_x64 ubuntu_14.04_x64 ubuntu_16.04_x64 ubuntu_16.04_x32 ubuntu_14.04_x32;do
    ./build_${v}.sh minc-build_$m DEB 2>&1 | tee logs/minc-build_${m}_${v}.log
  done

done

# building RPM data package
./build_data.sh minc-build_centos_7.3_x64 RPM 2>&1 | tee logs/minc-build_data_centos_7.3_x64.log

# building DEB data package
./build_data.sh minc-build_ubuntu_16.04_x64 DEB 2>&1 | tee logs/minc-build_data_ubuntu_16.04_x64.log
