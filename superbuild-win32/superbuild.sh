#!/bin/bash

# /**
# * Copyright by Ruman Gerst
# * Research Group Applied Systems Biology - Head: Prof. Dr. Marc Thilo Figge
# * https://www.leibniz-hki.de/en/applied-systems-biology.html
# * HKI-Center for Systems Biology of Infection
# * Leibniz Institute for Natural Product Research and Infection Biology - Hans Knöll Insitute (HKI)
# * Adolf-Reichwein-Straße 23, 07745 Jena, Germany
# *
# * This code is licensed under BSD 2-Clause
# * See the LICENSE file provided with this code for the full license.
# */

#
# Settings
#

# MISA++ sources
MISAXX_CORE_SOURCES="https://github.com/applied-systems-biology/misaxx-core/archive/master.zip"
MISAXX_ANALYZER_SOURCES="https://github.com/applied-systems-biology/misaxx-analyzer/archive/master.zip"
MISAXX_IMAGING_SOURCES="https://github.com/applied-systems-biology/misaxx-imaging/archive/master.zip"
MISAXX_OME_SOURCES="https://github.com/applied-systems-biology/misaxx-ome/archive/master.zip"
MISAXX_OME_VISUALIZER_SOURCES="https://github.com/applied-systems-biology/misaxx-ome-visualizer/archive/master.zip"
MISAXX_TISSUE_SOURCES="https://github.com/applied-systems-biology/misaxx-tissue/archive/master.zip"
MISAXX_KIDNEY_GLOMERULI_SOURCES="https://github.com/applied-systems-biology/misaxx-kidney-glomeruli/archive/master.zip"

# JSON for Modern C++ sources
NLOHMANN_JSON_SOURCES="https://github.com/nlohmann/json/archive/v3.6.1.zip"

# OME sources
OME_COMMON_SOURCES="https://downloads.openmicroscopy.org/ome-common-cpp/5.5.0/source/ome-common-cpp-5.5.0.zip"
OME_MODEL_SOURCES="https://downloads.openmicroscopy.org/ome-model/5.6.0/source/ome-model-5.6.0.zip"
OME_FILES_SOURCES="https://downloads.openmicroscopy.org/ome-files-cpp/0.5.0/source/ome-files-cpp-0.5.0.zip"

# MSYS2 platform settings
MSYS2_PLATFORM=x86_64

# Number of threads for make
NUM_THREADS=4

# CMake build types
BUILD_PLATFORM=$MSYS2_PLATFORM
DEPENDENCY_CMAKE_BUILD_TYPE=Release
MISAXX_CMAKE_BUILD_TYPE=Release

# Static/shared builds
SHARED_BUILD_DEPENDENCIES=OFF
SHARED_BUILD_OME=OFF
SHARED_BUILD_MISAXX=OFF

# Installation prefix
INSTALL_PREFIX=/mingw64/

#
# Install dependencies 
#

pacman -S --noconfirm --needed unzip mingw-w64-$MSYS2_PLATFORM-cmake \
wget \
mingw-w64-$MSYS2_PLATFORM-toolchain \
mingw-w64-$MSYS2_PLATFORM-boost \
mingw-w64-$MSYS2_PLATFORM-make \
libsqlite \
libsqlite-devel \
mingw-w64-$MSYS2_PLATFORM-opencv \
mingw-w64-$MSYS2_PLATFORM-libtiff \
mingw-w64-$MSYS2_PLATFORM-xerces-c \
mingw-w64-$MSYS2_PLATFORM-xalan-c \
mingw-w64-$MSYS2_PLATFORM-libpng \
mingw-w64-$MSYS2_PLATFORM-python2

# Make compiling easier
cp /mingw64/bin/mingw32-make /mingw64/bin/make

function dependency_cmake_build {
	mkdir -p $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	pushd $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	cmake -DCMAKE_BUILD_TYPE=$DEPENDENCY_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_DEPENDENCIES -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
	make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
	make install
	popd
}

function misaxx_cmake_build {
	mkdir -p $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	pushd $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	cmake -DCMAKE_BUILD_TYPE=$MISAXX_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_MISAXX -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
	make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
	make install
	popd
}

function download_if_not_exist {
    if [ ! -e $2 ]; then
		if [ ! -e $2.zip ]; then
			wget -O $2.zip $1 || { echo "Download of $1 failed" ; exit 1; }
        fi
        unzip -o $2.zip || { echo "Extracting $2.zip failed" ; exit 1; }
    fi
}

#
# JSON for Modern C++
#

download_if_not_exist $NLOHMANN_JSON_SOURCES json-3.6.1
dependency_cmake_build json-3.6.1

#
# Build MISA++ Core, Analyzer, Imaging
#

download_if_not_exist $MISAXX_CORE_SOURCES misaxx-core-master
download_if_not_exist $MISAXX_ANALYZER_SOURCES misaxx-analyzer-master
download_if_not_exist $MISAXX_IMAGING_SOURCES misaxx-imaging-master

misaxx_cmake_build misaxx-core-master
misaxx_cmake_build misaxx-analyzer-master
misaxx_cmake_build misaxx-imaging-master

#
# Build OME Files & dependencies
#

function ome_dependency_cmake_build {
	mkdir -p $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	pushd $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	cmake -Ddoxygen=OFF -Drelocatable-install=ON -DCMAKE_BUILD_TYPE=$DEPENDENCY_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_OME -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit 1; }
	make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
	make install
	popd
}

download_if_not_exist $OME_COMMON_SOURCES ome-common-cpp-5.5.0
download_if_not_exist $OME_MODEL_SOURCES ome-model-5.6.0
if [ ! -e ome-files-cpp-0.5.0 ]; then
	download_if_not_exist $OME_FILES_SOURCES ome-files-cpp-0.5.0
	
	## We need to manually add bcrypt to the list of libraries (otherwise there will be an error)
	echo "" >> ome-files-cpp-0.5.0/lib/ome/files/CMakeLists.txt
	echo "# Boost UUID requires bcrypt on MSYS2" >> ome-files-cpp-0.5.0/lib/ome/files/CMakeLists.txt
	echo "target_link_libraries(ome-files bcrypt)" >> ome-files-cpp-0.5.0/lib/ome/files/CMakeLists.txt
fi

# OME Common
ome_dependency_cmake_build ome-common-cpp-5.5.0

# OME Model
ome_dependency_cmake_build ome-model-5.6.0

# OME Files
ome_dependency_cmake_build ome-files-cpp-0.5.0

#
# Build MISA++ Tissue segmentation, Glomeruli segmentation
#

download_if_not_exist $MISAXX_OME_SOURCES misaxx-core-master
download_if_not_exist $MISAXX_OME_VISUALIZER_SOURCES misaxx-ome-visualizer-master
download_if_not_exist $MISAXX_TISSUE_SOURCES misaxx-tissue-master
download_if_not_exist $MISAXX_KIDNEY_GLOMERULI_SOURCES misaxx-kidney-glomeruli-master

misaxx_cmake_build misaxx-ome-master
misaxx_cmake_build misaxx-ome-visualizer-master
misaxx_cmake_build misaxx-tissue-master
misaxx_cmake_build misaxx-kidney-glomeruli-master
