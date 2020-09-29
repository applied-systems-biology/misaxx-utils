#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with root permissions:"
    echo "sudo $0 $*"
    exit 1
fi

IMAGE_NAME="ome-build/focal"
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

cat >./bin/README.txt << EOL
MISA++ Linux binaries
-----------------
This folder contains following compiled binaries:
* MISA++ Core
* MISA++ Analyzer
* MISA++ OME visualizer
* MISA++ Tissue segmentation
* MISA++ Kidney glomeruli segmentation
* MISA++ for ImageJ (plugin)

MISA++ installation
=================

Run following command in the folder that contains the *.deb files:

sudo apt install ./*.deb


ImageJ plugin installation
=================

Copy all files in ./misa-imagej/plugins/ and ./misa-imagej/jars/ into their respective directories within the Fiji app (<Fiji.app>) folder

Navigate to Plugins > MISA++ for ImageJ to run the plugin


Copyright
=================

Copyright by Ruman Gerst
Research Group Applied Systems Biology - Head: Prof. Dr. Marc Thilo Figge
https://www.leibniz-hki.de/en/applied-systems-biology.html
HKI-Center for Systems Biology of Infection
Leibniz Institute for Natural Product Research and Infection Biology - Hans Knöll Insitute (HKI)
Adolf-Reichwein-Straße 23, 07745 Jena, Germany
The project code is licensed under BSD 2-Clause.
See the LICENSE.txt file provided with the code for the full license.
EOL

# Create LICENSE.txt

cat >bin/LICENSE.txt << EOL
BSD 2-Clause License
Copyright (c) 2019, Ruman Gerst
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
EOL


# Create zip package
pushd bin
zip -rv misaxx-linux-ubuntu-20.04.zip *
popd

# Change ownership back to the calling user
if ! [ -z "$SUDO_USER" ]; then
    chown -R $SUDO_USER:$SUDO_USER bin
fi

docker rm $CONTAINER_ID
