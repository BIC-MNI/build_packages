#! /bin/sh

VM=$1
OUT=$2

if [ -z $OUT ];then
echo "Usage $0 <vm> <DEB|RPM>"
exit
fi

if [ -z $PARALLEL ];then
PARALLEL=3
fi


echo "Running docker on $VM "
echo "PARALLEL=$PARALLEL"

# make sure output directory is writable to the container
mkdir -p packages
chmod a+w packages

docker run --rm -i -t --volume $(pwd)/packages:/home/nistmni/build $VM  /bin/bash <<END
mkdir src
cd src
git clone --recursive --branch develop https://github.com/BIC-MNI/minc-toolkit.git minc-toolkit
mkdir -p build/minc-toolkit
cd build/minc-toolkit
cmake ../../minc-toolkit \
-DCMAKE_BUILD_TYPE:STRING=Release   \
-DCMAKE_INSTALL_PREFIX:PATH=/opt/minc/1.0.09 \
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
-DMT_BUILD_QUIET:BOOL=ON \
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
