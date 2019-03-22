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

# OpenCV Toolbox sources
OPENCV_TOOLBOX_SOURCES="https://asb-git.hki-jena.de/RGerst/opencv-toolbox.git"

# LEMON Graph library sources
LEMON_SOURCES="https://asb-git.hki-jena.de/RGerst/opencv-toolbox.git"

# OME sources
OME_COMMON_SOURCES="https://downloads.openmicroscopy.org/ome-common-cpp/5.5.0/source/ome-common-cpp-5.5.0.zip"
OME_MODEL_SOURCES="https://downloads.openmicroscopy.org/ome-model/5.6.0/source/ome-model-5.6.0.zip"
OME_FILES_SOURCES="https://downloads.openmicroscopy.org/ome-files-cpp/0.5.0/source/ome-files-cpp-0.5.0.zip"

# Number of threads for make
NUM_THREADS=1


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
	cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/mingw64/ -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit; }
	make -j$NUM_THREADS || { echo 'Build failed' ; exit; }
	make install
	popd
}

function download_if_not_exist {
    if [ ! -e $2 ]; then
        wget -nc -O $2.zip $1 || { echo 'Download of $1 failed' ; exit; }
        unzip $2.zip || { echo "Extracting $2.zip failed" ; exit; }
    fi
}

#
# JSON for Modern C++
#

download_if_not_exist $NLOHMANN_JSON_SOURCES json-3.6.1
standard_cmake_build json-3.6.1

#
# Build MISA++ Core, Analyzer, Imaging
#

download_if_not_exist $MISAXX_CORE_SOURCES misaxx-core
download_if_not_exist $MISAXX_ANALYZER_SOURCES misaxx-analyzer
download_if_not_exist $MISAXX_IMAGING_SOURCES misaxx-imaging

standard_cmake_build misaxx-core
standard_cmake_build misaxx-analyzer
standard_cmake_build misaxx-imaging

#
# Build OME Files & dependencies
#

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
standard_cmake_build ome-common-cpp-5.5.0

# OME Model
standard_cmake_build ome-model-5.6.0

# OME Files
standard_cmake_build ome-files-cpp-0.5.0

#
# Build OpenCV Toolbox
#

download_if_not_exist $OPENCV_TOOLBOX_SOURCES opencv-toolbox
standard_cmake_build opencv-toolbox

#
# Build LEMON graph library
#

download_if_not_exist $LEMON_SOURCES lemon-1.3.1
standard_cmake_build lemon-1.3.1

#
# Build MISA++ Tissue segmentation, Glomeruli segmentation
#

download_if_not_exist $MISAXX_OME_SOURCES misaxx-core
download_if_not_exist $MISAXX_OME_VISUALIZER_SOURCES misaxx-ome-visualizer
download_if_not_exist $MISAXX_TISSUE_SOURCES misaxx-tissue
download_if_not_exist $MISAXX_KIDNEY_GLOMERULI_SOURCES misaxx-kidney-glomeruli

standard_cmake_build misaxx-ome
standard_cmake_build misaxx-ome-visualizer
standard_cmake_build misaxx-tissue
standard_cmake_build misaxx-kidney-glomeruli
