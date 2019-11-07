#!/bin/bash

OME_COMMON_SOURCES="https://downloads.openmicroscopy.org/ome-common-cpp/5.5.0/source/ome-common-cpp-5.5.0.zip"

source ./commons.sh

download_zip_if_not_exist $OME_COMMON_SOURCES ome-common-cpp-5.5.0

mkdir -p ome-common-cpp-5.5.0/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
pushd ome-common-cpp-5.5.0/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
cmake -Ddoxygen=OFF -Drelocatable-install=ON -DXalanC_LIBRARY=$INSTALL_PREFIX/lib/libxalan-c.so -DCMAKE_BUILD_TYPE=$DEPENDENCY_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_OME -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit 1; }
make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
make install
popd
