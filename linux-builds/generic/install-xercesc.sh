#!/bin/bash

XERCESC_SOURCES="https://www-us.apache.org/dist/xerces/c/3/sources/xerces-c-3.2.2.tar.gz"

source ./commons.sh

download_targz_if_not_exist $XERCESC_SOURCES xerces-c-3.2.2
  

mkdir -p xerces-c-3.2.2/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
pushd xerces-c-3.2.2/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
cmake -Dnetwork:BOOL=OFF -DCMAKE_BUILD_TYPE=$DEPENDENCY_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
make install
popd
