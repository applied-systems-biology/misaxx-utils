# MISA++ generic build

This is an experimental Docker-less build meant for any Linux system that fulfills the requirements.
We do not guarantee that it will work. If you want reliable builds, use a Docker build or
extract the Docker build commands for your system.

## Prerequisites

* wget
* GCC 7 or higher
* libcurl and development files
* libtiff and development files
* libpng and development files
* GNU automake
* Python 2
* ZLib and development files

## Building

Run `./build.sh` to start the build process.
Then run `./package.sh` to create the MISA++ for ImageJ package.

## Running MISA++

You can find starter scripts for the C++ applications in `./misaxx-starters`. 
The `./misax-imagej` folder contains the MISA++ for ImageJ plugin.
