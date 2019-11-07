#!/bin/bash

NLOHMANN_JSON_SOURCES="https://github.com/nlohmann/json/archive/v3.6.1.zip"

source ./commons.sh

download_zip_if_not_exist $NLOHMANN_JSON_SOURCES json-3.6.1
dependency_cmake_build json-3.6.1
