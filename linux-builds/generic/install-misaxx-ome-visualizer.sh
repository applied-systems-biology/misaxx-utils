#!/bin/bash

MISAXX_OME_VISUALIZER_SOURCES="https://github.com/applied-systems-biology/misaxx-ome-visualizer/archive/master.zip"

source ./commons.sh

download_zip_if_not_exist $MISAXX_OME_VISUALIZER_SOURCES misaxx-ome-visualizer-master

mkdir -p misaxx-ome-visualizer-master/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
pushd misaxx-ome-visualizer-master/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
cmake -DXalanC_LIBRARY=$INSTALL_PREFIX/lib/libxalan-c.so -DCMAKE_BUILD_TYPE=$MISAXX_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_MISAXX -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
make install
popd
