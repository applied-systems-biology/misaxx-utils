#!/bin/bash

BOOST_SOURCES="https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.gz"

source ./commons.sh

download_targz_if_not_exist $BOOST_SOURCES boost_1_67_0

pushd boost_1_67_0
./bootstrap.sh --prefix=$INSTALL_PREFIX
./b2 --with-filesystem --with-program_options --with-log --with-regex --with-iostreams install
popd
