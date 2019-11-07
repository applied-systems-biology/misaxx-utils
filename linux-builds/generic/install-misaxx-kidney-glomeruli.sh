#!/bin/bash

MISAXX_KIDNEY_GLOMERULI_SOURCES="https://github.com/applied-systems-biology/misaxx-kidney-glomeruli/archive/master.zip"

source ./commons.sh

download_zip_if_not_exist $MISAXX_KIDNEY_GLOMERULI_SOURCES misaxx-kidney-glomeruli-master

mkdir -p misaxx-kidney-glomeruli-master/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
pushd misaxx-kidney-glomeruli-master/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
cmake -DXalanC_LIBRARY=$INSTALL_PREFIX/lib/libxalan-c.so -DCMAKE_BUILD_TYPE=$MISAXX_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_MISAXX -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
make install
popd
