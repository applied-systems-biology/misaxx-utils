# MISA++ Linux builds

This folder contains automated build scripts that utilize Docker to build MISA++ and the MISA++ ImageJ plugin.
The build scripts output ready-to-install packages and plugin files.

Run `sudo ./build.sh` to execute the building process. The output can be found in the `bin` directory.

## Installation (Ubuntu)

After building, navigate into the `bin` directory and run `sudo apt install ./*.deb` to install MISA++
and dependency packages.

To install the ImageJ plugin, download Fiji from https://fiji.sc/ and copy the contents of `bin/misa-imagej` into 
the Fiji plugin folder. Alternatively, we provide a ready-to-use Fiji distribution that contains the MISA++
ImageJ plugin: https://github.com/applied-systems-biology/misa-framework/releases/download/1.0.0/misa-imagej-linux.zip
