#!/bin/bash

SQLITE3_SOURCES="https://www.sqlite.org/2019/sqlite-autoconf-3300100.tar.gz"

source ./commons.sh

download_targz_if_not_exist $SQLITE3_SOURCES sqlite-autoconf-3300100

AUTOMAKE_CONFIG=$(automake --print-libdir)/config.guess

pushd sqlite-autoconf-3300100
rm config.guess
cp -v $AUTOMAKE_CONFIG .
make clean
./configure --prefix=$INSTALL_PREFIX && make && make install
popd
