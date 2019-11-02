#!/bin/bash

XALANC_SOURCES="https://www-eu.apache.org/dist/xalan/xalan-c/sources/xalan_c-1.11-src.zip"

source ./commons.sh

download_if_not_exist $XALANC_SOURCES xalan-c-1.11

# Set environment variables
export XERCESCROOT=/usr/include/xercesc
export XALANCROOT=$PWD/xalan-c-1.11/c/

# The Makefile has code like $DESTDIR/$libdir where DESTDIR is empty. This causes
# double-slashes // that are interpreted by Cygwin as network drives
export DESTDIR=/.

pushd xalan-c-1.11/c/
rm config.guess
cp /usr/share/automake-1.16/config.guess .
./runConfigure -p cygwin -c gcc -x g++ -b 64 -P $PWD/bin
make clean
make
make install
cp -v ./lib/cygxalanMsg111.dll /lib
pushd lib
cp -v *.dll /bin
popd
popd