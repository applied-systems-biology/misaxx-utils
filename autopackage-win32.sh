 #!/bin/bash
 
# /**
# * Copyright by Ruman Gerst
# * Research Group Applied Systems Biology - Head: Prof. Dr. Marc Thilo Figge
# * https://www.leibniz-hki.de/en/applied-systems-biology.html
# * HKI-Center for Systems Biology of Infection
# * Leibniz Institute for Natural Product Research and Infection Biology - Hans Knöll Insitute (HKI)
# * Adolf-Reichwein-Straße 23, 07745 Jena, Germany
# *
# * This code is licensed under BSD 2-Clause
# * See the LICENSE file provided with this code for the full license.
# */

OUTPUT_WIN32_FIJI=$PWD/misa-imagej-fiji-standalone-win32.zip
OUTPUT_PLUGIN=$PWD/misa-imagej-plugin.zip

rm $OUTPUT_WIN32_FIJI
rm $OUTPUT_PLUGIN

pushd superbuild-win32
    ./superbuild.sh || { echo 'Win32 superbuild failed' ; exit; }
    ./package-fiji.sh || { echo 'Fiji package failed' ; exit; }
    pushd Fiji.app
        zip -r $OUTPUT_WIN32_FIJI .
    popd
popd
pushd package-fiji
    ./package-fiji.sh || { echo 'Fiji plugin package failed' ; exit; }
    pushd misa-imagej-package
        zip -r $OUTPUT_PLUGIN .
    popd
popd
