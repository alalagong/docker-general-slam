FROM alalag/general-slam:base

LABEL Name=general Version=0.0.1
MAINTAINER YiQun GONG<gongyiqun51237@163.com>

ENV PCL_VERSION="pcl-1.8.0rc2"
ENV JOBS_NUM="1"
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /root/Library

RUN git clone https://github.com/PointCloudLibrary/pcl.git && \
    cd pcl && git checkout ${PCL_VERSION} && \
    mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

EXPOSE 5900
EXPOSE 22

ENTRYPOINT ["./startup.sh"]