FROM centos:6.9

# install basic system packages
RUN \
    yum -y update && \
    yum -y install deltarpm redhat-lsb-core wget bc which && \
    yum -y groupinstall 'Development Tools'  && \
    yum -y install sudo libX11-devel libXmu-devel libXi-devel \
                   mesa-libGL-devel mesa-libGLU-devel \
                   libjpeg-turbo-devel openjpeg-devel \
                   openssl-devel rpm-build-libs rpm-devel && \
    yum -y clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/*

# Install newer gcc, binutils, gfortran, libjpegturbo
RUN wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo && \
    yum install -y -q devtoolset-2-gcc-c++ devtoolset-2-binutils devtoolset-2-gcc-gfortran && \
    yum -y clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/* && \
    rpm -i https://sourceforge.net/projects/libjpeg-turbo/files/1.3.1/libjpeg-turbo-official-1.3.1.x86_64.rpm/download && \
    echo "/opt/libjpeg-turbo/lib64" >> /etc/ld.so.conf && \
    rm /etc/ld.so.cache && \
    ldconfig
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
