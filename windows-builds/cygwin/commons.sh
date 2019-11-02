#!/bin/bash

INSTALL_PREFIX=/usr

# Number of threads for make
NUM_THREADS=4

# CMake build types
BUILD_PLATFORM=x86_64
DEPENDENCY_CMAKE_BUILD_TYPE=Release
MISAXX_CMAKE_BUILD_TYPE=Release

# Static/shared builds
SHARED_BUILD_DEPENDENCIES=OFF
SHARED_BUILD_OME=OFF
SHARED_BUILD_MISAXX=OFF

function download_if_not_exist {
    if [ ! -e $2 ]; then
		if [ ! -e $2.zip ]; then
			wget --no-check-certificate -O $2.zip $1 || { echo "Download of $1 failed" ; exit 1; } # --no-check-certificate is needed because anti-viruses break the certificate chain
        fi
        unzip -o $2.zip || { echo "Extracting $2.zip failed" ; exit 1; }
    fi
}

function dependency_cmake_build {
	mkdir -p $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	pushd $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	cmake -DCMAKE_BUILD_TYPE=$DEPENDENCY_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_DEPENDENCIES -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
	make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
	make install
	popd
}


