#!/bin/bash

FIJI_DOWNLOAD="https://downloads.imagej.net/fiji/latest/fiji-win64.zip"
MISA_EXECUTABLES=(misaxx-analyzer misaxx-ome-visualizer misaxx-tissue-segmentation misaxx-kidney-glomeruli-segmentation)

source ./commons.sh

rm -r bin
mkdir bin

##
# MISA C++ framework binaries
##

# Copy executables into the bin folder
# This includes dependencies
for application in ${MISA_EXECUTABLES[@]}; do
	APP_PATH=/usr/bin/${application}.exe
	for lib in $(cygcheck $APP_PATH); do
		if [[ "$lib" =~ ^C:\\Windows.* ]]; then
			echo "skipping $lib"
		else
			cp -v $lib ./bin
		fi		
	done
done

# Copy the necessary OME models over
mkdir -p bin/ome_home/share/
cp -rv /usr/share/xml bin/ome_home/share/
cp -rv /usr/share/xsl bin/ome_home/share/

# Create batch starters equivalent to all executables
# They set OME_HOME=./ome_home/
# The Batch script converts Windows paths into Cygwin paths (otherwise it does not work)
pushd bin
for exe in ${MISA_EXECUTABLES[@]}; do
	cat > ${exe}.bat << EOF
@echo off
set OME_HOME=%~dp0
set OME_HOME=%OME_HOME%ome_home
set OME_HOME=%OME_HOME:\=/%

set OME_HOME=%OME_HOME:A:/=/cygdrive/a/%
set OME_HOME=%OME_HOME:B:/=/cygdrive/b/%
set OME_HOME=%OME_HOME:C:/=/cygdrive/c/%
set OME_HOME=%OME_HOME:D:/=/cygdrive/d/%
set OME_HOME=%OME_HOME:E:/=/cygdrive/e/%
set OME_HOME=%OME_HOME:F:/=/cygdrive/f/%
set OME_HOME=%OME_HOME:G:/=/cygdrive/g/%
set OME_HOME=%OME_HOME:H:/=/cygdrive/h/%
set OME_HOME=%OME_HOME:I:/=/cygdrive/i/%
set OME_HOME=%OME_HOME:J:/=/cygdrive/j/%
set OME_HOME=%OME_HOME:K:/=/cygdrive/k/%
set OME_HOME=%OME_HOME:L:/=/cygdrive/l/%
set OME_HOME=%OME_HOME:M:/=/cygdrive/m/%
set OME_HOME=%OME_HOME:N:/=/cygdrive/n/%
set OME_HOME=%OME_HOME:O:/=/cygdrive/o/%
set OME_HOME=%OME_HOME:P:/=/cygdrive/p/%
set OME_HOME=%OME_HOME:Q:/=/cygdrive/q/%
set OME_HOME=%OME_HOME:R:/=/cygdrive/r/%
set OME_HOME=%OME_HOME:S:/=/cygdrive/s/%
set OME_HOME=%OME_HOME:T:/=/cygdrive/t/%
set OME_HOME=%OME_HOME:U:/=/cygdrive/u/%
set OME_HOME=%OME_HOME:V:/=/cygdrive/v/%
set OME_HOME=%OME_HOME:W:/=/cygdrive/w/%
set OME_HOME=%OME_HOME:X:/=/cygdrive/x/%
set OME_HOME=%OME_HOME:Y:/=/cygdrive/y/%
set OME_HOME=%OME_HOME:Z:/=/cygdrive/z/%
%~dp0\EXECUTABLE %*
EOF

sed -i 's/$/\r/' ${exe}.bat
sed -i "s/EXECUTABLE/${exe}.exe/" ${exe}.bat

done
popd

# Create README
cat >./bin/README.txt << EOL
MISA++ Windows binaries
-----------------

This folder contains following compiled binaries:

* MISA++ Core
* MISA++ Analyzer
* MISA++ OME visualizer
* MISA++ Tissue segmentation
* MISA++ Kidney glomeruli segmentation
* MISA++ for ImageJ (plugin)

ImageJ plugin installation
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

##
# MISA++ for ImageJ
##

# Copy MISA++ for ImageJ into the bin folder
mkdir -p bin/misa-imagej/plugins
mkdir -p bin/misa-imagej/jars

cp misa-imagej-master/target/misa_imagej-*.jar bin/misa-imagej/plugins

# Copy dependencies
cp misa-imagej-master/target/dependencies/autolink*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/flexmark*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/graphics2d*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/jfreesvg*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/openhtmltopdf*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/pdfbox*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/poi*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/sqlite*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/bcprov-jdk15on*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/bcpkix-jdk15on*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/icepdf*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/commons-exec*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/xmlbeans*.jar bin/misa-imagej/jars \
&& cp misa-imagej-master/target/dependencies/commons-collections4*.jar bin/misa-imagej/jars

##
# Create Fiji all-in-one package
##
rm -rvf Fiji.app
download_if_not_exist $FIJI_DOWNLOAD Fiji.app

cp -rv bin/misa-imagej/plugins/* Fiji.app/plugins
cp -rv bin/misa-imagej/jars/* Fiji.app/jars

cat > bin/misa-imagej/README.txt << EOL
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

cat >bin/misa-imagej/LICENSE.txt << EOL
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

# Copy the binaries over
mkdir -p Fiji.app/plugins/misa-modules/bin/
cp -rv bin/*.dll Fiji.app/plugins/misa-modules/bin/
cp -rv bin/*.exe Fiji.app/plugins/misa-modules/bin/
cp -rv bin/*.bat Fiji.app/plugins/misa-modules/bin/
cp -rv bin/ome_home Fiji.app/plugins/misa-modules/bin/

# Create module links, so the ImageJ plugin can find the applications
pushd Fiji.app/plugins/misa-modules/bin/
for exe in ${MISA_EXECUTABLES[@]}; do
	cat >../${exe}.json << EOL
{
    "operating-system" : "Windows",
    "architecture" : "x64",
    "executable-path" : "bin/EXECUTABLE"
}
EOL
sed -i "s/EXECUTABLE/${exe}.bat/" ../${exe}.json
done
popd

# Create README
cat >Fiji.app/README-MISA.txt << EOL
MISA++ for ImageJ
-----------------

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

cat >Fiji.app/LICENSE-MISA.txt << EOL
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

##
# zip packages
##

rm misaxx-fiji-aio-windows.zip
rm misaxx-bin-windows.zip
rm misa-imagej-plugin.zip

pushd Fiji.app
zip -r ../misaxx-fiji-aio-windows.zip *
popd 

pushd bin
zip -r ../misaxx-bin-windows.zip *
popd 

pushd bin/misa-imagej
zip -r ../../misa-imagej-plugin.zip *
popd 