FROM i386/centos:6

#Fix broken i386 build https://github.com/CentOS/sig-cloud-instance-images/issues/94
RUN echo "i386" > /etc/yum/vars/basearch

#Install EPEL repo
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

# install basic system packages
RUN \
    yum -y update && \
    yum -y install deltarpm && \
    yum -y install rpm-build && \
    curl -L https://raw.githubusercontent.com/WatershedArts/fake-lpr/master/fake-lpr.spec --output fake-lpr.spec && \
    rpmbuild -ba fake-lpr.spec && \
    yum -y install /root/rpmbuild/RPMS/noarch/fake-lpr-1.0-1.noarch.rpm && \
    yum -y install redhat-lsb-core bc which && \
    yum -y --exclude=systemtap* --exclude=subversion* --exclude=gettext-devel* --exclude=intltool* --exclude=cairo* --exclude=swig* groupinstall 'Development Tools' && \
    yum -y install gcc-c++ gcc-gfortran bison flex && \
    yum -y install sudo libX11-devel libXmu-devel libXi-devel \
                   mesa-libGL-devel mesa-libGLU-devel \
                   openssl-devel rpm-build-libs rpm-devel ccache && \
    yum -y clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/*

# Install newer gcc, binutils, gfortran, libjpegturbo
# `rpm --import` related to centos 6 bug 0008226
RUN curl -L --output /etc/yum.repos.d/devtools-2.repo https://people.centos.org/tru/devtools-2/devtools-2.repo && \
    curl -L --output /etc/yum.repos.d/libjpeg-turbo.repo https://libjpeg-turbo.org/pmwiki/uploads/Downloads/libjpeg-turbo.repo && \
    gpg --keyserver keyserver.ubuntu.com --recv 0x85C7044E033FDE16 && \
    rm -rf /usr/lib/libjpeg* && \
    yum install -y -q devtoolset-2-gcc-c++ \
                      devtoolset-2-binutils \
                      devtoolset-2-gcc-gfortran \
                      libjpeg-turbo-official-1.3.1-20140321.i386 && \
    yum -y clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/* && \
    ln -sfv /opt/libjpeg-turbo/lib/lib*.so* /usr/lib && \
    ln -sfv /opt/libjpeg-turbo/include/*.h /usr/include && \
    cp -sfv /opt/rh/devtoolset-2/root/usr/bin/strip /usr/bin/strip

ENV BASH_ENV=/opt/rh/devtoolset-2/enable \
    ENV=/opt/rh/devtoolset-2/enable \
    PROMPT_COMMAND=". /opt/rh/devtoolset-2/enable"

SHELL ["/bin/bash", "-c"]

# add user to build all tools
RUN useradd -ms /bin/bash nistmni && \
    echo "nistmni ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nistmni && \
    chmod 0440 /etc/sudoers.d/nistmni

# add new cmake
RUN mkdir src && \
    cd src && \
    curl -L --output cmake-3.14.5.tar.gz https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5.tar.gz  && \
    tar zxf cmake-3.14.5.tar.gz && \
    cd cmake-3.14.5 && \
    ./configure --prefix=/usr --no-qt-gui && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf src

USER nistmni
ENV HOME /home/nistmni
WORKDIR /home/nistmni

ENTRYPOINT ["/usr/bin/linux32", "--"]
