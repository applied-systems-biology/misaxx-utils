#!/bin/bash

CMAKE_SOURCES="https://cmake.org/files/v3.13/cmake-3.13.5.tar.gz"

source ./commons.sh

download_targz_if_not_exist $CMAKE_SOURCES cmake-3.13.5

pushd cmake-3.13.5
chmod +x ./bootstrap
./bootstrap --system-curl --prefix=$INSTALL_PREFIX
make -j$NUM_THREADS
make install
popd
