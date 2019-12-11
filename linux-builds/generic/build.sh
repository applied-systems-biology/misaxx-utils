#!/bin/bash

# Build & install dependencies
./install-cmake.sh || { echo 'Build failed' ; exit 1; }
./install-nlohmann-json.sh || { echo 'Build failed' ; exit 1; }
./install-opencv.sh || { echo 'Build failed' ; exit 1; }
./install-xercesc.sh || { echo 'Build failed' ; exit 1; }
./install-xalanc.sh || { echo 'Build failed' ; exit 1; }
./install-boost.sh || { echo 'Build failed' ; exit 1; }
./install-sqlite3.sh || { echo 'Build failed' ; exit 1; }
./install-ome-common.sh || { echo 'Build failed' ; exit 1; }
./install-ome-model.sh || { echo 'Build failed' ; exit 1; }
./install-ome-files.sh || { echo 'Build failed' ; exit 1; }

# Build & install MISA++ core components
./install-misaxx-core.sh || { echo 'Build failed' ; exit 1; }
./install-misaxx-analyzer.sh || { echo 'Build failed' ; exit 1; }

# Build & install MISA++ example components
./install-misaxx-imaging.sh || { echo 'Build failed' ; exit 1; }
./install-misaxx-microbench.sh || { echo 'Build failed' ; exit 1; }
./install-misaxx-deconvolve.sh || { echo 'Build failed' ; exit 1; }
./install-misaxx-segment-cells.sh || { echo 'Build failed' ; exit 1; }
./install-misaxx-ome.sh || { echo 'Build failed' ; exit 1; }
./install-misaxx-ome-visualizer.sh || { echo 'Build failed' ; exit 1; }
./install-misaxx-tissue.sh || { echo 'Build failed' ; exit 1; }
./install-misaxx-kidney-glomeruli.sh || { echo 'Build failed' ; exit 1; }

# Build MISA++ for ImageJ
./build-misa-imagej.sh

echo "Build finished. Now run ./package.sh to extract the executables from Cygwin"
