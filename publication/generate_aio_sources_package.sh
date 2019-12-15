#!/bin/bash

export MISAXX_VERSION=1.0.0.1

rm -rf misaxx-sources-bin-aio
mkdir misaxx-sources-bin-aio

pushd misaxx-sources-bin-aio

# Download sources
git clone https://github.com/applied-systems-biology/misaxx-softwarex-code.git all-sources
pushd all-sources
git submodule init
git submodule update --remote
popd

# Copy README

cp ../sources_README.md ./README.md
cp ../LICENSE.txt .

# Package everything together
zip -r ../misaxx-$MISAXX_VERSION-sources-aio.zip ./*
