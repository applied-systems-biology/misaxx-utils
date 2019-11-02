#!/bin/bash

MISAXX_ANALYZER_SOURCES="https://github.com/applied-systems-biology/misaxx-analyzer/archive/master.zip"

source ./commons.sh

download_if_not_exist $MISAXX_ANALYZER_SOURCES misaxx-analyzer-master

mkdir -p misaxx-analyzer-master/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
pushd misaxx-analyzer-master/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
cmake -DCMAKE_BUILD_TYPE=$MISAXX_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_MISAXX -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
make install
popd