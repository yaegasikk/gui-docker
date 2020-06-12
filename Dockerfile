FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04

ARG OPENCV_VERSION=3.4.3

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y sudo cmake g++ gcc gfortran libhdf5-dev pkg-config build-essential unzip wget curl git htop tmux  ffmpeg rsync openssh-server python3 python3-dev libpython3-dev 
RUN apt-get -y autoremove && apt-get -y clean && apt-get -y autoclean 
RUN apt-get install -y python3-pip  python3-dev python3-numpy python3-tk
RUN apt-get install -y x11-apps
RUN apt-get install -y snapd && rm -rf /var/lib/apt/lists/*

RUN sudo pip3 install --upgrade pip
RUN sudo pip3 install matplotlib scipy==1.2.1　
RUN sudo pip3 install scikit-learn==0.17.0 scikit-image
RUN sudo pip3 install progressbar2
RUN sudo pip3 install setuptools==41.0.0
RUN sudo apt-get update -y 

# OpenCV3 インストール
RUN apt update && \
         apt install -y --no-install-recommends \
               ca-certificates \
               libgtk2.0-dev \
               libjpeg-dev libpng-dev \
               libavcodec-dev \
               libavformat-dev \
               libavresample-dev \
               libswscale-dev \
               libv4l-dev \
               libtbb2 \
               libtbb-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/opencv
WORKDIR /tmp/opencv
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
        unzip ${OPENCV_VERSION}.zip -d . && \
        mkdir /tmp/opencv/opencv-${OPENCV_VERSION}/build && \
        rm ${OPENCV_VERSION}.zip

RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
	unzip opencv_contrib.zip && \
        rm opencv_contrib.zip

WORKDIR /tmp/opencv/opencv-${OPENCV_VERSION}/build/
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
                    -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv/opencv_contrib-${OPENCV_VERSION}/modules/ \
                    -D BUILD_TESTS=OFF \
                    -D CMAKE_BUILD_TYPE=RELEASE \
                    -D BUILD_PERF_TESTS=OFF \
                    -D WITH_FFMPEG=ON \
                    -D WITH_TBB=ON .. && \
       make -j "$(nproc)" && \
       make install && \
       make clean

RUN sudo pip3 install tensorflow-gpu==1.15
RUN sudo pip3 install cvbase


RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN apt-get install -y xauth
RUN echo AddressFamily inet >> /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

WORKDIR /user/local/


RUN apt-get -y update && apt-get -y upgrade