FROM ioft/i386-ubuntu:16.04

# install basic system packages
RUN apt-get -y update && \
    apt-get install -y \
         sudo \
         build-essential g++ gfortran bc \
         bison flex \
         libx11-dev x11proto-core-dev \
         libxi6 libxi-dev \
         libxmu6 libxmu-dev libxmu-headers \
         libgl1-mesa-dev libglu1-mesa-dev \
         libjpeg-dev \
         wget libssl-dev ccache libapt-inst2.0 git lsb-release && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

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
    ./configure --prefix=/usr --no-server --no-qt-gui --enable-ccache && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf src 

USER nistmni
ENV HOME /home/nistmni
WORKDIR /home/nistmni
