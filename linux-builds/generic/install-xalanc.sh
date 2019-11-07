#!/bin/bash

XALANC_SOURCES="https://www-eu.apache.org/dist/xalan/xalan-c/sources/xalan_c-1.11-src.tar.gz"

source ./commons.sh

download_targz_if_not_exist $XALANC_SOURCES xalan-c-1.11

# Set environment variables
export XERCESCROOT=$INSTALL_PREFIX/include/xercesc
export XALANCROOT=$PWD/xalan-c-1.11/c/

pushd xalan-c-1.11/c/
rm config.guess
cp /usr/share/automake-1.16/config.guess .
./runConfigure -p linux -c gcc -x g++ -b 64 -P $INSTALL_PREFIX
make clean
make
make install
