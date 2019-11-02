#!/bin/bash

# Please update the download links accordingly if there are changes
JDK_DOWNLOAD="https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u232-b09/OpenJDK8U-jdk_x64_windows_hotspot_8u232b09.zip"
JDK_NAME=jdk8u232-b09
MAVEN_DOWNLOAD="https://www-us.apache.org/dist/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.zip"
MAVEN_NAME=apache-maven-3.6.2
MISA_IMAGEJ_SOURCES="https://github.com/applied-systems-biology/misa-imagej/archive/master.zip"

source ./commons.sh

echo "Downloading OpenJDK8 and Maven"
echo "Please update the download links in ./build-misa-imagej.sh if the downloads fail"
download_if_not_exist $JDK_DOWNLOAD $JDK_NAME
download_if_not_exist $MAVEN_DOWNLOAD $MAVEN_NAME

PATH=$PWD/$MAVEN_NAME/bin/:$PWD/$JDK_NAME/bin/:$PATH

# Build MISA++ for ImageJ
download_if_not_exist $MISA_IMAGEJ_SOURCES "misa-imagej-master"
pushd misa-imagej-master
mvn package || { echo 'Building MISA++ for ImageJ failed' ; exit; }
popd

# Fix dependencies (jfreesvg missing)
pushd misa-imagej-master/target/dependencies 
wget --no-check-certificate -nc "http://maven.imagej.net/content/groups/public/org/jfree/jfreesvg/3.3/jfreesvg-3.3.jar"
popd