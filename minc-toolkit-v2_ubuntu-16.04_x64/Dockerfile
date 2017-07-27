FROM ubuntu:xenial

# install basic system packages
RUN apt-get -y update && \
    apt-get install -y \
         bc \
         libxi6  \
         libxmu6  \
         wget libjpeg8 imagemagick perl libgl1-mesa-glx libglu1-mesa && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

# install minc-toolkit 1.9.15
RUN wget http://packages.bic.mni.mcgill.ca/minc-toolkit/Debian/minc-toolkit-1.9.15-20170529-Ubuntu_16.04-x86_64.deb  && \
    dpkg -i minc-toolkit-1.9.15-20170529-Ubuntu_16.04-x86_64.deb && \
    rm -f minc-toolkit-1.9.15-20170529-Ubuntu_16.04-x86_64.deb && \
    wget http://packages.bic.mni.mcgill.ca/minc-toolkit/Debian/beast-library-1.1.0-20121212.deb && \
    dpkg -i beast-library-1.1.0-20121212.deb && \
    rm -f beast-library-1.1.0-20121212.deb && \
    wget http://packages.bic.mni.mcgill.ca/minc-toolkit/Debian/bic-mni-models-0.1.1-20120421.deb && \
    dpkg -i bic-mni-models-0.1.1-20120421.deb && \
    rm -f bic-mni-models-0.1.1-20120421.deb

# add user to execute commands
RUN useradd -ms /bin/bash nistmni 
#     echo "nistmni ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nistmni && \
#     chmod 0440 /etc/sudoers.d/nistmni
    

# source minc environment automatically
# RUN ln -sf /opt/minc/1.9.15/minc-toolkit-config.sh /etc/profile.d/

RUN echo ". /opt/minc/1.9.15/minc-toolkit-config.sh" >> /home/nistmni/.bashrc
    
USER nistmni
ENV HOME /home/nistmni
WORKDIR /home/nistmni
