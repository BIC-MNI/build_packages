FROM centos:7

#Install EPEL
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# install basic system packages
RUN \
    yum -y update && \
    yum -y install deltarpm redhat-lsb-core wget bc which && \
    yum -y groupinstall 'Development Tools'  && \
    yum -y install sudo libX11-devel libXmu-devel libXi-devel \
                   mesa-libGL-devel mesa-libGLU-devel \
                   libjpeg-turbo-devel openjpeg-devel \
                   openssl-devel rpm-build-libs rpm-devel ccache && \
    yum -y autoremove && \
    yum -y clean all 

# add user to build all tools
RUN useradd -ms /bin/bash nistmni && \
    echo "nistmni ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nistmni && \
    chmod 0440 /etc/sudoers.d/nistmni

# add new cmake
RUN mkdir src && \
    cd src && \
    curl --output cmake-3.13.4.tar.gz https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz  && \
    tar zxf cmake-3.13.4.tar.gz && \
    cd cmake-3.13.4 && \
    ./configure --prefix=/usr --no-qt-gui --enable-ccache  && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf src

USER nistmni
ENV HOME /home/nistmni
WORKDIR /home/nistmni
