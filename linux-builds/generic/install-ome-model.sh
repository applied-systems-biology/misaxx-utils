#!/bin/bash

OME_MODEL_SOURCES="https://downloads.openmicroscopy.org/ome-model/5.6.0/source/ome-model-5.6.0.zip"

source ./commons.sh

rm -rvf ome-model-5.6.0
download_zip_if_not_exist $OME_MODEL_SOURCES ome-model-5.6.0

# The OME source code breaks, as the developers decided to use _N, _E, _T as template variables
# Apply a patch to fix this issue
pushd ome-model-5.6.0/ome-xml/src/main/cpp/ome/xml/model/primitives/
cat >ConstrainedNumeric.patch <<EOL
--- ConstrainedNumeric.h	2017-12-01 11:04:54.000000000 +0100
+++ ConstrainedNumeric.h	2019-11-02 15:50:05.578916000 +0100
@@ -534,13 +534,13 @@
            */
           template<class _charT,
                    class _traits,
-                   typename _N,
-                   typename _C,
-                   typename _E>
+                   typename N0,
+                   typename C0,
+                   typename E0>
           friend
           std::basic_istream<_charT,_traits>&
           operator>> (std::basic_istream<_charT,_traits>& is,
-                      ConstrainedNumeric<_N, _C, _E>&     value);
+                      ConstrainedNumeric<N0, C0, E0>&     value);
         };
 
         /**
EOL
cp ConstrainedNumeric.h ConstrainedNumeric.h.old
patch < ConstrainedNumeric.patch
popd

# OME xsd-fu breaks due to Python 3 being the default in modern systems
pushd ome-model-5.6.0/xsd-fu
    for file in $(find .); do
        sed -i -e "s|#!/usr/bin/env python|#!/usr/bin/env $PYTHON_ENV|g" $file
    done
popd

mkdir -p ome-model-5.6.0/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
pushd ome-model-5.6.0/build-$MISAXX_CMAKE_BUILD_TYPE-$BUILD_PLATFORM
cmake -Ddoxygen=OFF -Drelocatable-install=ON -DCMAKE_BUILD_TYPE=$DEPENDENCY_CMAKE_BUILD_TYPE -DBUILD_SHARED_LIBS=$SHARED_BUILD_OME -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -G "Unix Makefiles" .. || { echo 'Build configuration failed' ; exit 1; }
make -j$NUM_THREADS || { echo 'Build failed' ; exit 1; }
make install
popd
