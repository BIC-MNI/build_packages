#! /bin/sh

VM=$1
OUT=$2
KEEP=$3

if [ -z $OUT ];then
echo "Usage $0 <vm> <DEB|RPM> [keep]"
exit
fi

VM=$1

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
chmod a+w packages

docker run ${KEEP} -i --volume $(pwd)/packages:/home/nistmni/build --volume $(pwd)/cache:/home/nistmni/cache $VM  /bin/bash <<END
mkdir src
cd src
git clone --recursive --branch develop-1.9.16 https://github.com/BIC-MNI/minc-toolkit-v2.git minc-toolkit-v2
mkdir -p build/minc-toolkit-v2
cd build/minc-toolkit-v2
ln -s /home/nistmni/cache
cmake ../../minc-toolkit-v2 \
-DCMAKE_BUILD_TYPE:STRING=Release   \
-DCMAKE_INSTALL_PREFIX:PATH=/opt/minc/1.9.16 \
-DMT_BUILD_ABC:BOOL=ON   \
-DMT_BUILD_ANTS:BOOL=ON   \
-DMT_BUILD_C3D:BOOL=ON   \
-DMT_BUILD_ELASTIX:BOOL=ON   \
-DMT_BUILD_IM:BOOL=OFF   \
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
cpack -G ${OUT} &&
cp -v *.rpm *.deb ~/build/
# run tests separately
make test > ~/build/test_${VM}_v2.txt
END

exit
