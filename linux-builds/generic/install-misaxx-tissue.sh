#!/bin/bash

MISAXX_TISSUE_SOURCES="https://github.com/applied-systems-biology/misaxx-tissue/archive/master.zip"

source ./commons.sh

download_if_not_exist $MISAXX_TISSUE_SOURCES misaxx-tissue-master

mkdir -p misaxx-tissue-master/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
pushd misaxx-tissue-master/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
cmake -DXalanC_LIBRARY=/bin/libxalan-c.dll -DCMAKE_BUILD_TYPE=$MISAXX_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_MISAXX -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
make install
popd