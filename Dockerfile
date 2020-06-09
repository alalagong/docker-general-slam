FROM alalag/general-slam:pcl

LABEL Name=general Version=0.0.1
MAINTAINER YiQun GONG<gongyiqun51237@163.com>

ENV CERES_VERSION="1.13.0"
ENV JOBS_NUM="2"
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /root/Library

RUN git clone https://github.com/jbeder/yaml-cpp.git && \
    cd yaml-cpp && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

RUN git clone https://github.com/uzh-rpg/fast.git && \
    cd fast && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

RUN git clone https://github.com/ceres-solver/ceres-solver.git && \
	cd ceres-solver && git checkout ${CERES_VERSION} && \
	mkdir build && cd build && \
	cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*


RUN git clone https://github.com/rmsalinas/DBow3.git && \
    cd DBow3 && mkdir build && cd build && \
    cmake .. && make -j${JOBS_NUM} install && \
    rm -rf /root/Library/*

EXPOSE 5900
EXPOSE 22

ENTRYPOINT ["./startup.sh"]