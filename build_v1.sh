#!/bin/bash

VM=$1
OUT=$2
KEEP=$3

if [ -z $OUT ];then
  echo "Usage $0 <vm> <DEB|RPM> [keep]"
  exit
fi

if [ -z $PARALLEL ];then
  PARALLEL=3
fi

echo "Running docker on $VM"
echo "PARALLEL=$PARALLEL"

if [ -z $KEEP ];then
  KEEP="--rm"
else
  KEEP=""
fi

# make sure output directory is writable to the container
mkdir -p packages
mkdir -p cache
mkdir -p ccache
chmod a+w packages
chmod a+w cache
chmod a+w ccache

docker run ${KEEP} -i -v $(pwd)/minc-toolkit:/home/nistmni/minc-toolkit -v $(pwd)/packages:/home/nistmni/build -v $(pwd)/cache:/home/nistmni/cache -v $(pwd)/ccache:/ccache $VM  /bin/bash <<END
set -x
export CCACHE_DIR=/ccache
mkdir src
cd src
ln -s /home/nistmni/minc-toolkit
VERSION="\$(grep -o -E "MINC_TOOLKIT_PACKAGE_VERSION_MAJOR [0-9]+" minc-toolkit/CMakeLists.txt | cut -d " " -f 2)"
VERSION="\${VERSION}.\$(grep -o -E "MINC_TOOLKIT_PACKAGE_VERSION_MINOR [0-9]+" minc-toolkit/CMakeLists.txt | cut -d " " -f 2)"
VERSION="\${VERSION}.\$(grep -o -E "MINC_TOOLKIT_PACKAGE_VERSION_PATCH [0-9]+" minc-toolkit/CMakeLists.txt | cut -d " " -f 2)"
mkdir -p build/minc-toolkit
cd build/minc-toolkit
ln -s /home/nistmni/cache
cmake ../../minc-toolkit \
-DCMAKE_BUILD_TYPE:STRING=Release   \
-DCMAKE_INSTALL_PREFIX:PATH=/opt/minc/\${VERSION} \
-DMNI_AUTOREG_OLD_AMOEBA_INIT:BOOL=ON \
-DMT_BUILD_MINC_ANTS:BOOL=ON \
-DMT_BUILD_C3D:BOOL=ON   \
-DMT_BUILD_ITK_TOOLS:BOOL=ON   \
-DMT_BUILD_LITE:BOOL=OFF   \
-DMT_BUILD_SHARED_LIBS:BOOL=ON   \
-DMT_BUILD_VISUAL_TOOLS:BOOL=ON   \
-DMT_USE_OPENMP:BOOL=ON   \
-DMT_BUILD_OPENBLAS:BOOL=ON \
-DMT_BUILD_SHARED_LIBS:BOOL=ON \
-DBUILD_TESTING:BOOL=ON \
-DMT_BUILD_LITE:BOOL=OFF \
-DUSE_SYSTEM_GLUT:BOOL=OFF \
-DUSE_SYSTEM_FFTW3D:BOOL=OFF   \
-DUSE_SYSTEM_FFTW3F:BOOL=OFF   \
-DUSE_SYSTEM_GLUT:BOOL=OFF   \
-DUSE_SYSTEM_GSL:BOOL=OFF   \
-DUSE_SYSTEM_HDF5:BOOL=OFF   \
-DUSE_SYSTEM_ITK:BOOL=OFF   \
-DUSE_SYSTEM_NETCDF:BOOL=OFF   \
-DUSE_SYSTEM_NIFTI:BOOL=OFF   \
-DUSE_SYSTEM_PCRE:BOOL=OFF   \
-DUSE_SYSTEM_ZLIB:BOOL=OFF  && \
make -j${PARALLEL} &&
cpack -G $OUT &&
cp -v *.deb *.rpm ~/build/
# run tests separately
make test > ~/build/test_${VM}_v1.txt
END
exit
