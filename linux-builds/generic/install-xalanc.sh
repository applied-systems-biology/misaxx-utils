#!/bin/bash

XALANC_SOURCES="https://www-eu.apache.org/dist/xalan/xalan-c/sources/xalan_c-1.11-src.tar.gz"

source ./commons.sh

download_targz_if_not_exist $XALANC_SOURCES xalan-c-1.11

# Set environment variables
export XERCESCROOT=$INSTALL_PREFIX/include/xercesc
export XALANCROOT=$PWD/xalan-c-1.11/c/

AUTOMAKE_CONFIG=$(automake --print-libdir)/config.guess

pushd xalan-c-1.11/c/
rm config.guess
cp -v $AUTOMAKE_CONFIG .
./runConfigure -p linux -c gcc -x g++ -b 64 -P $INSTALL_PREFIX
make clean
make
make install
