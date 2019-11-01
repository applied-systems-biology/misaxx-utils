#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with root permissions:"
    echo "sudo $0 $*"
    exit 1
fi

IMAGE_NAME="ome-build/eoan"
docker build -t $IMAGE_NAME .
CONTAINER_ID=$(docker create $IMAGE_NAME)

# Package and extract results
docker cp $CONTAINER_ID:/results.tar.gz bin.tar.gz
rm -rv bin
mkdir bin
pushd bin
    tar -xvf ../bin.tar.gz
popd
rm bin.tar.gz

# Create README
echo "This folder contains ready-to-install binaries for MISA++" >> bin/README
echo "" >> bin/README
echo "Install the packages in following order:" >> bin/README
echo "* OME Common (Only needed if OME is not installed)" >> bin/README
echo "* OME Model (Only needed if OME is not installed)" >> bin/README
echo "* OME Files (Only needed if OME is not installed)" >> bin/README
echo "* MISA++ Core" >> bin/README
echo "* MISA++ Analyzer" >> bin/README
echo "* MISA++ Imaging" >> bin/README
echo "* MISA++ OME" >> bin/README
echo "* MISA++ Tissue" >> bin/README
echo "* MISA++ Kidney Glomeruli" >> bin/README
echo "" >> bin/README
echo "To install the ImageJ plugin, copy the contents of the 'misa-imagej' folder into Fiji's plugin directory." >> bin/README

# Change ownership back to the calling user
if ! [ -z "$SUDO_USER" ]; then
    chown -R $SUDO_USER:$SUDO_USER bin
fi

docker rm $CONTAINER_ID
