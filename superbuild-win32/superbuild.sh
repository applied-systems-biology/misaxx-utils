#!/bin/bash

#
# Install dependencies 
#

pacman -S --noconfirm --needed unzip mingw-w64-x86_64-cmake \
mingw-w64-x86_64-toolchain \
mingw-w64-x86_64-boost \
mingw-w64-x86_64-make \
libsqlite \
libsqlite-devel \
mingw-w64-x86_64-opencv \
mingw-w64-x86_64-libtiff \
mingw-w64-x86_64-xerces-c \
mingw-w64-x86_64-xalan-c \
mingw-w64-x86_64-libpng \
mingw-w64-x86_64-python2

# Make compiling easier
cp /mingw64/bin/mingw32-make /mingw64/bin/make

function standard_cmake_build {
	mkdir -p $1/build
	pushd $1/build
	cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/mingw64/ -G "Unix Makefiles" .. || { echo 'Build failed' ; exit; }
	make || { echo 'Build failed' ; exit; }
	make install
	popd
}

#
# JSON for Modern C++
#

if [ ! -e json-3.6.1 ]; then
	wget -nc -O nlohmann-json-v3.6.1.zip https://github.com/nlohmann/json/archive/v3.6.1.zip || { echo 'Build failed' ; exit; }
	unzip nlohmann-json-v3.6.1.zip || { echo 'Build failed' ; exit; }
fi

standard_cmake_build json-3.6.1

#
# Build MISA++ Core, Analyzer, Imaging
#

standard_cmake_build misaxx-core
standard_cmake_build misaxx-analyzer
standard_cmake_build misaxx-imaging

#
# Build OME Files & dependencies
#

if [ ! -e ome-common-cpp-5.5.0 ]; then
	wget -nc https://downloads.openmicroscopy.org/ome-common-cpp/5.5.0/source/ome-common-cpp-5.5.0.zip || { echo 'Build failed' ; exit; }
	unzip ome-common-cpp-5.5.0.zip || { echo 'Build failed' ; exit; }
fi
if [ ! -e ome-model-5.6.0 ]; then
	wget -nc https://downloads.openmicroscopy.org/ome-model/5.6.0/source/ome-model-5.6.0.zip || { echo 'Build failed' ; exit; }
	unzip ome-model-5.6.0.zip || { echo 'Build failed' ; exit; }
fi
if [ ! -e ome-files-cpp-0.5.0 ]; then
	wget -nc https://downloads.openmicroscopy.org/ome-files-cpp/0.5.0/source/ome-files-cpp-0.5.0.zip || { echo 'Build failed' ; exit; }
	unzip ome-files-cpp-0.5.0 || { echo 'Build failed' ; exit; }
	
	## We need to manually add bcrypt to the list of libraries (otherwise there will be an error)
	echo "" >> ome-files-cpp-0.5.0/lib/ome/files/CMakeLists.txt
	echo "# Boost UUID requires bcrypt on MSYS2" >> ome-files-cpp-0.5.0/lib/ome/files/CMakeLists.txt
	echo "target_link_libraries(ome-files bcrypt)" >> ome-files-cpp-0.5.0/lib/ome/files/CMakeLists.txt
fi

# OME Common
standard_cmake_build ome-common-cpp-5.5.0

# OME Model
standard_cmake_build ome-model-5.6.0

# OME Files
standard_cmake_build ome-files-cpp-0.5.0

#
# Build OpenCV Toolbox
#

standard_cmake_build opencv-toolbox

#
# Build LEMON graph library
#

wget http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.zip
unzip lemon-1.3.1.zip
standard_cmake_build lemon-1.3.1

#
# Build MISA++ Tissue segmentation, Glomeruli segmentation
#

standard_cmake_build misaxx-ome
standard_cmake_build misaxx-ome-visualizer
standard_cmake_build misaxx-tissue
standard_cmake_build misaxx-kidney-glomeruli
