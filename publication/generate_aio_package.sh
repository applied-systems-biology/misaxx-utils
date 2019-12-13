#!/bin/bash

export MISAXX_VERSION=1.0.0.1

rm -rf misaxx-sources-bin-aio
mkdir misaxx-sources-bin-aio

pushd misaxx-sources-bin-aio

# Download sources
git clone https://github.com/applied-systems-biology/misaxx-softwarex-code.git all-sources
pushd all-sources
git submodule init
git submodule update --remote
popd

# Download MISA++ binaries
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misaxx-linux-ubuntu-18.04.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misaxx-linux-ubuntu-19.10.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misaxx-fiji-aio-windows.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misaxx-bin-windows.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misa-imagej-plugin.zip

mkdir bin-linux
unzip misaxx-linux-ubuntu-18.04.zip -d bin-linux/misaxx-linux-ubuntu-18.04
unzip misaxx-linux-ubuntu-19.10.zip -d bin-linux/misaxx-linux-ubuntu-19.10

mkdir bin-windows
unzip misaxx-fiji-aio-windows.zip -d bin-windows/fiji-all-in-one
unzip misaxx-bin-windows.zip -d bin-windows/misaxx-bin

rm misaxx-linux-ubuntu-18.04.zip
rm misaxx-linux-ubuntu-19.10.zip
rm misaxx-fiji-aio-windows.zip
rm misaxx-bin-windows.zip
rm misa-imagej-plugin.zip

# Download Java binaries
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/aio-java-imglib2-bin.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misa-imagej-plugin.zip

mkdir bin-java

unzip misa-imagej-plugin.zip -d bin-java/misa-imagej-plugin
unzip aio-java-imglib2-bin.zip -d bin-java/imglib2-implementations

rm aio-java-imglib2-bin.zip
rm misa-imagej-plugin.zip

# Download example data
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misaxx_kidney_glomeruli_example_data.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/python_java_kidney_glomeruli_example_data.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misaxx_segment_cells_example_data.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/python_java_segment_cells_example_data.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misaxx_deconvolve_example_data.zip
wget https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misaxx_microbench_example_data.zip

mkdir example-data
unzip misaxx_kidney_glomeruli_example_data.zip -d example-data/misaxx_kidney_glomeruli
unzip python_java_kidney_glomeruli_example_data.zip -d example-data/python_java_kidney_glomeruli
unzip misaxx_segment_cells_example_data.zip -d example-data/misaxx_segment_cells
unzip python_java_segment_cells_example_data.zip -d example-data/python_java_segment_cells
unzip misaxx_deconvolve_example_data.zip -d example-data/misaxx_deconvolve
unzip misaxx_microbench_example_data.zip -d example-data/misaxx_microbench

rm misaxx_kidney_glomeruli_example_data.zip
rm python_java_kidney_glomeruli_example_data.zip
rm misaxx_segment_cells_example_data.zip
rm python_java_segment_cells_example_data.zip
rm misaxx_deconvolve_example_data.zip
rm misaxx_microbench_example_data.zip

# Copy README

cp ../_README.md ./README.md
cp ../LICENSE.txt .

# Package everything together
zip ../misaxx-$MISAXX_VERSION-sources-bin-aio.zip ./*
