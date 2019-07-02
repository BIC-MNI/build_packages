FROM ubuntu:cosmic

# install basic system packages
RUN apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends \
         sudo \
         build-essential g++ gfortran bc \
         bison flex \
         libx11-dev x11proto-core-dev \
         libxi6 libxi-dev \
         libxmu6 libxmu-dev libxmu-headers \
         libgl1-mesa-dev libglu1-mesa-dev \
         libjpeg-dev \
         libssl-dev ccache libapt-inst2.0 git lsb-release \
         curl ca-certificates && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

# add user to build all tools
RUN useradd -ms /bin/bash nistmni && \
    echo "nistmni ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nistmni && \
    chmod 0440 /etc/sudoers.d/nistmni

ENV PATH=/usr/lib/ccache:$PATH

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
