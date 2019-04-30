#!/bin/bash

# /**
# * Copyright by Ruman Gerst
# * Research Group Applied Systems Biology - Head: Prof. Dr. Marc Thilo Figge
# * https://www.leibniz-hki.de/en/applied-systems-biology.html
# * HKI-Center for Systems Biology of Infection
# * Leibniz Institute for Natural Product Research and Infection Biology - Hans Knöll Insitute (HKI)
# * Adolf-Reichwein-Straße 23, 07745 Jena, Germany
# *
# * This code is licensed under BSD 2-Clause
# * See the LICENSE file provided with this code for the full license.
# */

# Downloads
MISA_IMAGEJ_SOURCES="https://github.com/applied-systems-biology/misa-imagej/archive/master.zip"
MAVEN_DOWNLOAD="ftp://ftp.fu-berlin.de/unix/www/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.zip"
FIJI_DOWNLOAD="https://downloads.imagej.net/fiji/latest/fiji-win64.zip"

function download_if_not_exist {
    if [ ! -e $2 ]; then
		if [ ! -e $2.zip ]; then
			wget --no-check-certificate -O $2.zip $1 || { echo "Download of $1 failed" ; exit 1; } # --no-check-certificate is needed because anti-viruses break the certificate chain
        fi
        unzip -o $2.zip || { echo "Extracting $2.zip failed" ; exit 1; }
    fi
}

# Download Maven
download_if_not_exist $MAVEN_DOWNLOAD "apache-maven"
mv apache-maven-* apache-maven
MAVEN_EXECUTABLE="$PWD/apache-maven/bin/mvn"

# Download and extract MISA++ for ImageJ
download_if_not_exist $MISA_IMAGEJ_SOURCES "misa-imagej-master"
pushd misa-imagej-master
$MAVEN_EXECUTABLE package || { echo 'Building MISA++ for ImageJ failed' ; exit 1; }
popd

# Create the target dir
rm -r misa-imagej-package
mkdir misa-imagej-package
mkdir -p misa-imagej-package/plugins
mkdir -p misa-imagej-package/jars

# Create README
cat >misa-imagej-package/README.txt << EOL
MISA++ for ImageJ
-----------------

Installation
=================

Copy all files in ./plugins/ and ./jars/ into their respective directories within the Fiji app folder


Usage
=================

Navigate to Plugins > MISA++ for ImageJ


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

cat >misa-imagej-package/LICENSE.txt << EOL
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

# Install the MISA++ for ImageJ plugin
cp ./misa-imagej-master/target/misa_imagej-*.jar ./misa-imagej-package/plugins/

# Download missing jfreesvg
pushd ./misa-imagej-master/target/dependencies/
wget http://maven.imagej.net/content/groups/public/org/jfree/jfreesvg/3.3/jfreesvg-3.3.jar 
popd

# Copy necessary dependencies
function copy_dependency {
	cp -v ./misa-imagej-master/target/dependencies/$1*.jar ./misa-imagej-package/jars/
}

copy_dependency autolink
copy_dependency flexmark
copy_dependency graphics2d
copy_dependency jfreesvg
copy_dependency openhtmltopdf
copy_dependency pdfbox
copy_dependency poi
copy_dependency sqlite
copy_dependency bcprov-jdk15on
copy_dependency bcpkix-jdk15on
copy_dependency icepdf
copy_dependency commons-exec
copy_dependency xmlbeans
copy_dependency commons-collections4

