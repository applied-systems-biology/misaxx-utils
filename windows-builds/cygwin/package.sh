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
mkdir -p bin/ome_home
cp -rv /usr/share/xml bin/ome_home/
cp -rv /usr/share/xsl bin/ome_home/

# Create batch starters equivalent to all executables
# They set OME_HOME=./ome_home/
pushd bin
for exe in ${MISA_EXECUTABLES[@]}; do
	cat > ${exe}.bat << EOF
@echo off
SET OME_HOME=%~dp0\ome_home
%~dp0\EXECUTABLE %*
EOF

sed -i 's/$/\r/' ${exe}.bat
sed -i "s/EXECUTABLE/${exe}.exe/" ${exe}.bat

done
popd


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