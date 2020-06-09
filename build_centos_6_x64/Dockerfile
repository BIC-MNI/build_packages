FROM centos:6

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
RUN yum install -y centos-release-scl && \
    yum install -y scl-utils scl-utils-build && \
    curl -L --output /etc/yum.repos.d/libjpeg-turbo.repo https://libjpeg-turbo.org/pmwiki/uploads/Downloads/libjpeg-turbo.repo && \
    gpg --keyserver keys.gnupg.net --recv 0x85C7044E033FDE16 && \
    rm -rf /usr/lib64/libjpeg* && \
    yum install --nogpgcheck -y -q devtoolset-7-gcc-c++ \
                      devtoolset-7-binutils \
                      devtoolset-7-gcc-gfortran \
                      libjpeg-turbo-official-1.3.1-20140321.x86_64 && \
    yum -y clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/* && \
    ln -sfv /opt/libjpeg-turbo/lib64/lib*.so* /usr/lib64 && \
    ln -sfv /opt/libjpeg-turbo/include/*.h /usr/include && \
    cp -sfv /opt/rh/devtoolset-7/root/usr/bin/strip /usr/bin/strip

ENV BASH_ENV=/opt/rh/devtoolset-7/enable \
    ENV=/opt/rh/devtoolset-7/enable \
    PROMPT_COMMAND=". /opt/rh/devtoolset-7/enable"

SHELL ["/bin/bash", "-c"]

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
