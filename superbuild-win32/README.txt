# MISA++ MSYS2 Superbuild

Compiles following MISA++ applications and libraries:

* MISA++ Core
* MISA++ Imaging
* MISA++ OME
* MISA++ Tissue Segmentation
* MISA++ Kidney Glomeruli Segmentation
* MISA++ OME Visualizer

## Prerequisites

* MSYS2 (https://www.msys2.org/)

## Build instructions

* Install MSYS2 and open a MSYS2 MinGW 64-bit terminal
* Only after first installation: Update MSYS2 by running `pacman -Syyu` and follow the instructions
* Navigate into the folder containing the superbuild script
* Run `./superbuild.sh`

## Creating standalone-packages

Run `./package.sh` to extract the MISA++ applications from MSYS2 into a folder that
contains all necessary dependencies.

## Creating a ready-to-use Fiji package

This requires you to install Maven (https://maven.apache.org/) and the Java Development Kit (https://java.com/).
Maven must be added to the PATH. If this is not possible, change the `package-fiji.sh` script.

* Make sure that ./package.py ran successfully
* Run `./package-fiji.sh`
