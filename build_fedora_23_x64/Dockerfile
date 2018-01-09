FROM fedora:23

# install basic system packages
RUN \
    yum -y update && \
    yum -y install redhat-lsb-core wget bc which && \
    yum -y groupinstall 'Development Tools' && \
    yum -y install gcc-c++ gcc-gfortran bison flex && \
    yum -y install sudo libX11-devel libXmu-devel libXi-devel \
                   mesa-libGL-devel mesa-libGLU-devel \
                   libjpeg-turbo-devel openjpeg-devel \
                   openssl-devel rpm-build-libs \
                   fedora-packager rpm-devel && \
    yum -y autoremove && \
    yum -y clean all 

# add user to build all tools
RUN useradd -ms /bin/bash nistmni && \
    echo "nistmni ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nistmni && \
    chmod 0440 /etc/sudoers.d/nistmni

# add new cmake
RUN mkdir src && \
    cd src && \
    wget https://cmake.org/files/v3.8/cmake-3.8.0.tar.gz  && \
    tar zxf cmake-3.8.0.tar.gz && \
    cd cmake-3.8.0 && \
    ./configure --prefix=/usr --no-server --no-qt-gui && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf src 

USER nistmni
ENV HOME /home/nistmni
WORKDIR /home/nistmni
