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

docker run ${KEEP} -i -t --volume $(pwd)/packages:/home/nistmni/build $VM  /bin/bash <<END

mkdir src
cd src
git clone --recursive --branch master https://github.com/BIC-MNI/minc-toolkit-testsuite.git minc-toolkit-testsuite  && \
mkdir -p build/minc-toolkit-testsuite  && \
cd build/minc-toolkit-testsuite  && \
cmake ../../minc-toolkit-testsuite -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/opt/minc && \
make -j${PARALLEL} && \
cpack -G ${OUT} && \
cp -v *.rpm *.deb ~/build/

cd ~/src/
git clone --recursive --branch master https://github.com/BIC-MNI/BEaST_library.git BEaST_library && \
mkdir -p build/BEaST_library  && \
cd build/BEaST_library && \
cmake ../../BEaST_library -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/opt/minc && \
make -j${PARALLEL} && \
cpack -G ${OUT} && \
cp -v *.rpm *.deb ~/build/

cd ~/src/
git clone --recursive --branch master https://github.com/BIC-MNI/bic-mni-models.git bic-mni-models && \
mkdir -p build/bic-mni-models && \
cd build/bic-mni-models && \
cmake ../../bic-mni-models -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/opt/minc && \
make -j${PARALLEL} && \
cpack -G ${OUT} && \
cp -v *.rpm *.deb ~/build/

END

exit
