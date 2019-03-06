FROM ubuntu:18.04
MAINTAINER wind_qq <wind_qq@163.com>

RUN apt-get update \
	&& apt-get remove openjdk* \
	&& apt-get install -y \
		apt-utils \
		openjdk-8-jdk \
		software-properties-common

ENV JAVA_HOME /usr/local/jdk1.8.0_141
ENV JRE_HOME ${JAVA_HOME}/jre
ENV CLASSPATH .:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV PATH ${JAVA_HOME}/bin:$PATH

RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y \
		build-essential \
		cmake \
		ant \
		wget \
		git \
		libgtk2.0-dev \
		pkg-config \
		libavcodec-dev \
		libavformat-dev \
		libswscale-dev \
		python-dev \
		python-numpy \
		libtbb2 \
		libtbb-dev \
		libjpeg-dev \
		libpng-dev \
		libtiff-dev \
		libjasper-dev \
		libdc1394-22-dev \
		libavcodec-dev \
		libavformat-dev \
		libswscale-dev \
		libv4l-dev \
		liblapacke-dev \
		libxvidcore-dev \
		libx264-dev \
		libatlas-base-dev \
		gfortran \
		ffmpeg \
		unzip \
		zip \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /
ENV OPENCV_VERSION "3.4.3"
RUN wget -O opencv-${OPENCV_VERSION}.zip https://github.com/Itseez/opencv/archive/${OPENCV_VERSION}.zip \
	&& unzip opencv-${OPENCV_VERSION}.zip \
	&& cd opencv-${OPENCV_VERSION} \
	&& mkdir build \
	&& cd build \
	&& cmake CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. \
	&& make & make install \
	&& cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -DBUILD_TESTS=OFF .. \
	&& make -j8 \
	&& make install \
	&& rm /opencv-${OPENCV_VERSION}.zip \
	&& rm -r /opencv-${OPENCV_VERSION} \
	&& echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf \
	&& idconfig

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/share/OpenCV/java:/../opencv-3.4.3/bulid/lib/:$LD_LIBRARY_PATH
