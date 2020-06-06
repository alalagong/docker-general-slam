FROM ubuntu:16.04

LABEL Name=general Version=0.0.1
MAINTAINER YiQun GONG<gongyiqun51237@163.com>

ENV OPENCV_VERSION="3.2.0"
ENV CERES_VERSION="1.13.0"
ENV PCL_VERSION="pcl-1.8.0rc2"
ENV SOPHUS_VERSION="v1.0.0"
ENV JOBS_NUM="4"
ENV username=gong
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get install -y \
    libboost-all-dev cmake-gui gnutls-bin\
	cmake git zsh autojump\
	libgoogle-glog-dev libsuitesparse-dev\
	libeigen3-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

# for Opencv
RUN apt-get -y update && apt-get install -y \
    libgtk2.0-dev pkg-config libswscale-dev\ 
    libavcodec-dev libavformat-dev \
    libjpeg.dev libtiff4.dev \
    python-numpy libjasper-dev libdc1394-22-dev\
    libpng-dev python-dev libtbb2 libtbb-dev  && \
    rm -rf /var/lib/apt/lists/*

# for g2o 
RUN apt-get -y update && apt-get install -y \
    qtdeclarative5-dev qt5-qmake libcholmod3.0.6\
    libglew-dev libqglviewer2 libqglviewer-dev && \
    rm -rf /var/lib/apt/lists/*

# bellow for pcl
RUN apt-get -y update && apt-get install -y \
    linux-libc-dev libusb-1.0-0-dev libusb-dev libudev-dev \
    mpi-default-dev openmpi-bin openmpi-common \
    libflann1.8 libflann-dev \
    libvtk5.10-qt4 libvtk5.10 libvtk5-dev \
    libqhull* libgtest-dev  && \
    rm -rf /var/lib/apt/lists/*

# too big two
RUN apt-get -y update && apt-get install -y mono-complete && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get -y update && apt-get install -y openjdk-8-jdk openjdk-8-jre && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get -y update && apt-get install -y \
    freeglut3-dev libxmu-dev libxi-dev \
    libxkbcommon-x11-dev libgl1-mesa-dev libgoogle-glog-dev \
    libopenni-dev libopenni2-dev supervisor \
	openssh-server vim-tiny \
	xfce4 xfce4-goodies \
	x11vnc xvfb pwgen && \ 
    apt-get autoclean  && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/alalagong/oh-my-zsh-gong.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc_gong.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh

RUN cd /root && mkdir Library

WORKDIR /root/Library

COPY ippicv_linux_20151201.tgz /root/Library

RUN git clone https://gitee.com/gongyiqunall/opencv.git && \
    cd opencv && git checkout ${OPENCV_VERSION} && \
    mkdir -p 3rdparty/ippicv/downloads/linux-808b791a6eac9ed78d32a7666804320e && \
    cp /root/Library/ippicv_linux_20151201.tgz  \ 
    3rdparty/ippicv/downloads/linux-808b791a6eac9ed78d32a7666804320e/ippicv_linux_20151201.tgz && \
    mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

RUN git clone https://gitee.com/gongyiqunall/g2o.git && \
    cd g2o && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

RUN git clone https://gitee.com/gongyiqunall/Pangolin.git && \
	cd Pangolin && mkdir build && cd build && \
	cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

RUN git clone https://gitee.com/gongyiqunall/pcl.git && \
    cd pcl && git checkout ${PCL_VERSION} && \
    mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

RUN git clone https://github.com/strasdat/Sophus.git && \
    cd Sophus && git checkout ${SOPHUS_VERSION} && \
    mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

RUN git clone https://gitee.com/gongyiqunall/yaml-cpp.git && \
    cd yaml-cpp && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

RUN git clone https://github.com/uzh-rpg/fast.git && \
    cd fast && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

RUN git clone https://gitee.com/gongyiqunall/ceres-solver.git && \
	cd ceres-solver && git checkout ${CERES_VERSION} && \
	mkdir build && cd build && \
	cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*


RUN git clone https://gitee.com/gongyiqunall/DBow3.git && \
    cd DBow3 && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

WORKDIR /root

ADD startup.sh ./
ADD supervisord.conf ./

EXPOSE 5900
EXPOSE 22

ENTRYPOINT ["./startup.sh"]

