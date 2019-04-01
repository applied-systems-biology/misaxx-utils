#!/bin/bash

# Downloads
MISA_IMAGEJ_SOURCES="https://asb-git.hki-jena.de/RGerst/misa-imagej/-/archive/master/misa-imagej-master.zip"
MAVEN_DOWNLOAD="ftp://ftp.fu-berlin.de/unix/www/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.zip"
FIJI_DOWNLOAD="https://downloads.imagej.net/fiji/latest/fiji-win64.zip"

function download_if_not_exist {
    if [ ! -e $2 ]; then
		if [ ! -e $2.zip ]; then
			wget -O $2.zip $1 || { echo "Download of $1 failed" ; exit; }
        fi
        unzip -o $2.zip || { echo "Extracting $2.zip failed" ; exit; }
    fi
}

# Download Maven
download_if_not_exist $MAVEN_DOWNLOAD "apache-maven"
mv apache-maven-* apache-maven
MAVEN_EXECUTABLE="$PWD/apache-maven/bin/mvn"

# Download and extract MISA++ for ImageJ
download_if_not_exist $MISA_IMAGEJ_SOURCES "misa-imagej"
pushd misa-imagej
$MAVEN_EXECUTABLE package || { echo 'Building MISA++ for ImageJ failed' ; exit; }
popd

# Download and extract Fiji
download_if_not_exist $FIJI_DOWNLOAD Fiji.App

# Install the MISA++ for ImageJ plugin
cp ./misa-imagej/target/misa_imagej-*.jar ./Fiji.app/plugins/

# Download missing jfreesvg
pushd ./misa-imagej/target/dependencies/
wget http://maven.imagej.net/content/groups/public/org/jfree/jfreesvg/3.3/jfreesvg-3.3.jar 
popd

# Copy necessary dependencies
function copy_dependency {
	cp -v ./misa-imagej/target/dependencies/$1*.jar ./Fiji.app/jars/
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

# Copy packages MISA++ modules
rm -rvf ./Fiji.app/plugins/misa-modules
mkdir -p ./Fiji.app/plugins/misa-modules
cp -rvf ./package-win32 ./Fiji.app/plugins/misa-modules/bin

# Create module links to the package 
for application in ./package-win32/*.bat; do
	cat >./Fiji.app/plugins/misa-modules/$(basename $application).json << EOL
{
    "operating-system" : "Windows",
    "architecture" : "x64",
    "executable-path" : "bin/$(basename $application)"
}
EOL
done

