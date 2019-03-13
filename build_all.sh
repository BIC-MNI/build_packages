#! /bin/bash

mkdir -p logs

# iterate over minc-toolkit-v1 and -2
for v in v1 v2;do

  # build RPM-based packages
  for m in build_centos_* build_fedora_* ; do
    ./build_${v}.sh minc-${m} RPM 2>&1 | tee logs/minc-${m}_${v}.log
  done

  # build DEB-based packages
  for m in build_debian* build_ubuntu* ; do
    ./build_${v}.sh minc-${m} DEB 2>&1 | tee logs/minc-${m}_${v}.log
  done

done

# Build minimal (no graphics) versions

# build RPM-based packages
for m in build_centos_* build_fedora_* ; do
  ./build_v2_min.sh minc-${m} RPM 2>&1 | tee logs/minc_min-${m}_${v}.log
done

# build DEB-based packages
for m in build_debian* build_ubuntu* ; do
  ./build_v2_min.sh minc-${m} DEB 2>&1 | tee logs/minc_min-${m}_${v}.log
done

# building RPM data package
./build_data.sh minc-build_centos_7_x64 RPM 2>&1 | tee logs/minc-build_data_centos_7.3_x64.log

# building DEB data package
./build_data.sh minc-build_ubuntu_16.04_x64 DEB 2>&1 | tee logs/minc-build_data_ubuntu_16.04_x64.log
