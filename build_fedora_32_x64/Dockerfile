FROM fedora:32

# install basic system packages
RUN \
    yum -y update && \
    yum -y install deltarpm && \
    yum -y install rpm-build && \
    curl -L https://raw.githubusercontent.com/WatershedArts/fake-lpr/master/fake-lpr.spec --output fake-lpr.spec && \
    rpmbuild -ba fake-lpr.spec && \
    yum -y install /root/rpmbuild/RPMS/noarch/fake-lpr-1.0-1.noarch.rpm && \
    yum -y install redhat-lsb-core bc which && \
    yum -y --exclude=systemtap* --exclude=subversion* --exclude=gettext-devel* --exclude=intltool* --exclude=swig* groupinstall 'Development Tools' && \
    yum -y install gcc-c++ gcc-gfortran bison flex && \
    yum -y install sudo libX11-devel libXmu-devel libXi-devel \
                   mesa-libGL-devel mesa-libGLU-devel \
                   libjpeg-turbo-devel openjpeg-devel \
                   openssl-devel rpm-build-libs \
                   fedora-packager rpm-devel ccache && \
    yum -y autoremove && \
    yum -y clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/*


# add user to build all tools
RUN useradd -ms /bin/bash nistmni && \
    echo "nistmni ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nistmni && \
    chmod 0440 /etc/sudoers.d/nistmni

# add new cmake
RUN mkdir src && \
    cd src && \
    curl -L --output cmake-3.17.3.tar.gz https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3.tar.gz  && \
    tar zxf cmake-3.17.3.tar.gz && \
    cd cmake-3.17.3 && \
    ./configure --prefix=/usr --no-qt-gui && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf src

USER nistmni
ENV HOME /home/nistmni
WORKDIR /home/nistmni
