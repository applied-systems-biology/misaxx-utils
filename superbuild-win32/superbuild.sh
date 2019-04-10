#!/bin/bash

#
# Settings
#

# MISA++ sources
MISAXX_CORE_SOURCES="https://asb-git.hki-jena.de/RGerst/misaxx-core/-/archive/master/misaxx-core-master.zip"
MISAXX_ANALYZER_SOURCES="https://asb-git.hki-jena.de/RGerst/misaxx-analyzer/-/archive/master/misaxx-analyzer-master.zip"
MISAXX_IMAGING_SOURCES="https://asb-git.hki-jena.de/RGerst/misaxx-imaging/-/archive/master/misaxx-imaging-master.zip"
MISAXX_OME_SOURCES="https://asb-git.hki-jena.de/RGerst/misaxx-ome/-/archive/master/misaxx-ome-master.zip"
MISAXX_OME_VISUALIZER_SOURCES="https://asb-git.hki-jena.de/RGerst/misaxx-ome-visualizer/-/archive/master/misaxx-ome-visualizer-master.zip"
MISAXX_TISSUE_SOURCES="https://asb-git.hki-jena.de/RGerst/misaxx-tissue/-/archive/master/misaxx-tissue-master.zip"
MISAXX_KIDNEY_GLOMERULI_SOURCES="https://asb-git.hki-jena.de/RGerst/misaxx-kidney-glomeruli/-/archive/master/misaxx-kidney-glomeruli-master.zip"

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
	make -j$NUM_THREADS || { echo 'Build failed' ; exit; }
	make install
	popd
}

function misaxx_cmake_build {
	mkdir -p $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	pushd $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	cmake -DCMAKE_BUILD_TYPE=$MISAXX_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_MISAXX -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
	make -j$NUM_THREADS || { echo 'Build failed' ; exit; }
	make install
	popd
}

function download_if_not_exist {
    if [ ! -e $2 ]; then
		if [ ! -e $2.zip ]; then
			wget -O $2.zip $1 || { echo "Download of $1 failed" ; exit; }
        fi
        unzip -o $2.zip || { echo "Extracting $2.zip failed" ; exit; }
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

download_if_not_exist $MISAXX_CORE_SOURCES misaxx-core
download_if_not_exist $MISAXX_ANALYZER_SOURCES misaxx-analyzer
download_if_not_exist $MISAXX_IMAGING_SOURCES misaxx-imaging

misaxx_cmake_build misaxx-core
misaxx_cmake_build misaxx-analyzer
misaxx_cmake_build misaxx-imaging

#
# Build OME Files & dependencies
#

function ome_dependency_cmake_build {
	mkdir -p $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	pushd $1/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
	cmake -Ddoxygen=OFF -Drelocatable-install=ON -DCMAKE_BUILD_TYPE=$DEPENDENCY_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_OME -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
	make -j$NUM_THREADS || { echo 'Build failed' ; exit; }
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

download_if_not_exist $MISAXX_OME_SOURCES misaxx-core
download_if_not_exist $MISAXX_OME_VISUALIZER_SOURCES misaxx-ome-visualizer
download_if_not_exist $MISAXX_TISSUE_SOURCES misaxx-tissue
download_if_not_exist $MISAXX_KIDNEY_GLOMERULI_SOURCES misaxx-kidney-glomeruli

misaxx_cmake_build misaxx-ome
misaxx_cmake_build misaxx-ome-visualizer
misaxx_cmake_build misaxx-tissue
misaxx_cmake_build misaxx-kidney-glomeruli
