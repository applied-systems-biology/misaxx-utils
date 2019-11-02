#!/bin/bash

OME_FILES_SOURCES="https://downloads.openmicroscopy.org/ome-files-cpp/0.5.0/source/ome-files-cpp-0.5.0.zip"

source ./commons.sh

download_if_not_exist $OME_FILES_SOURCES ome-files-cpp-0.5.0

mkdir -p ome-files-cpp-0.5.0/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
pushd ome-files-cpp-0.5.0/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
cmake -Ddoxygen=OFF -Drelocatable-install=ON -DXalanC_LIBRARY=/bin/libxalan-c.dll -DPNG_PNG_INCLUDE_DIR=/usr/include/libpng16 -DCMAKE_BUILD_TYPE=$DEPENDENCY_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_OME -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit 1; }
make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
make install
popd