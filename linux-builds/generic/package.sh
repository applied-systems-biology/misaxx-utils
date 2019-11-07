#!/bin/bash

MISA_EXECUTABLES=(misaxx-analyzer misaxx-ome-visualizer misaxx-tissue-segmentation misaxx-kidney-glomeruli-segmentation)

source ./commons.sh

rm -r ./misa-imagej
mkdir misa-imagej

##
# MISA++ starter executables
##

rm -r ./misaxx-starters
mkdir ./misaxx-starters

for executable in "${MISA_EXECUTABLES[@]}"; do
    cat > ./misaxx-starters/${executable}.sh << EOF
#!/bin/bash
export PATH=$INSTALL_PREFIX/bin:\$PATH
export LD_LIBRARY_PATH=$INSTALL_PREFIX/lib:\$LD_LIBRARY_PATH

$executable "\$@"
EOF
chmod +x ./misaxx-starters/${executable}.sh
done

##
# MISA++ for ImageJ
##

# Copy MISA++ for ImageJ into the bin folder
mkdir -p misa-imagej/plugins
mkdir -p misa-imagej/jars

cp misa-imagej-master/target/misa_imagej-*.jar misa-imagej/plugins

# Copy dependencies
cp misa-imagej-master/target/dependencies/autolink*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/flexmark*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/graphics2d*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/jfreesvg*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/openhtmltopdf*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/pdfbox*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/poi*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/sqlite*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/bcprov-jdk15on*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/bcpkix-jdk15on*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/icepdf*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/commons-exec*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/xmlbeans*.jar misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/commons-collections4*.jar misa-imagej/jars

cat > misa-imagej/README.txt << EOL
MISA++ for ImageJ
-----------------

Installation
=================

Copy all files in ./misa-imagej/plugins/ and ./misa-imagej/jars/ into their respective directories within the Fiji app (<Fiji.app>) folder

Usage
=================

Navigate to Plugins > MISA++ for ImageJ

To add a MISA++ application into the list, click "Add module" and select the *.bat file

Important note: The *.bat files are used to provide additional information to the dependency OME libraries.
If an application does not depend on OME (like misaxx-analyzer.exe), the *.exe file can be directly chosen.


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

cat >misa-imagej/LICENSE.txt << EOL
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
