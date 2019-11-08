#!/bin/bash

OPENCV_SOURCES="https://github.com/opencv/opencv/archive/3.2.0.zip"
OPENCV_CONTRIB_SOURCES="https://github.com/opencv/opencv_contrib/archive/3.2.0.zip"

source ./commons.sh

download_zip_if_not_exist $OPENCV_SOURCES opencv-3.2.0
download_zip_if_not_exist $OPENCV_CONTRIB_SOURCES opencv_contrib-3.2.0

OPENCV_CONTRIB_MODULES=$PWD/opencv_contrib-3.2.0/modules

mkdir -p opencv-3.2.0/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
pushd opencv-3.2.0/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM

cmake -DWITH_IPP=$OPENCV_ENABLE_THREADING -DWITH_TBB=$OPENCV_ENABLE_THREADING -DWITH_OPENMP=$OPENCV_ENABLE_THREADING -DWITH_PTHREADS_PF=$OPENCV_ENABLE_THREADING -DBUILD_opencv_matlab=OFF -DBUILD_opencv_python2=OFF -DBUILD_opencv_python3=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_video=OFF -DWITH_CUDA=OFF -DOPENCV_EXTRA_MODULES_PATH=$OPENCV_CONTRIB_MODULES -DCMAKE_BUILD_TYPE=$DEPENDENCY_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_OME -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit 1; }
make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
make install
popd
