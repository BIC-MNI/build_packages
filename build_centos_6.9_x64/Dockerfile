FROM centos:6.9

# install basic system packages
RUN \
    yum -y update && \
    yum -y install deltarpm redhat-lsb-core wget bc which && \
    yum -y groupinstall 'Development Tools'  && \
    yum -y install sudo libX11-devel libXmu-devel libXi-devel \
                   mesa-libGL-devel mesa-libGLU-devel \
                   openssl-devel rpm-build-libs rpm-devel && \
    yum -y clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/*

# Install newer gcc, binutils, gfortran, libjpegturbo
# `rpm --import` related to centos 6 bug 0008226
RUN wget -O /etc/yum.repos.d/devtools-2.repo http://people.centos.org/tru/devtools-2/devtools-2.repo && \
    wget -O /etc/yum.repos.d/libjpeg-turbo.repo https://libjpeg-turbo.org/pmwiki/uploads/Downloads/libjpeg-turbo.repo && \
    rpm --import "http://pgp.mit.edu/pks/lookup?op=get&search=0x85C7044E033FDE16" && \
    rm -rf /usr/lib64/libjpeg* && \
    yum install -y -q devtoolset-2-gcc-c++ \
                      devtoolset-2-binutils \
                      devtoolset-2-gcc-gfortran \
                      libjpeg-turbo-official-1.3.1-20140321.x86_64 && \
    yum -y clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/* && \
    ln -sfv /opt/libjpeg-turbo/lib64/lib*.so* /usr/lib64 && \
    ln -sfv /opt/libjpeg-turbo/include/*.h /usr/include
ENV PATH=/opt/rh/devtoolset-2/root/usr/bin:$PATH

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
