#!/usr/bin/env python2

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

# Configuration
applications = [
    "misaxx-analyzer.exe",
    "misaxx-tissue-segmentation.exe",
    "misaxx-kidney-glomeruli-segmentation.exe",
    "misaxx-ome-visualizer.exe"
]
package_path = "./package-win32"

shared_paths = [
	"/mingw64/share/xml",
	"/mingw64/share/xsl"
]

# Script
from subprocess import check_output
import shutil
import os


def cygpath(file):
    return check_output(["cygpath", "-w", file]).strip()


def which(file):
    return check_output(["which", file]).strip()


def list_libraries(executable):
    out = check_output(["ldd", executable])
    for line_ in out.split("\n"):
        line = line_.strip()
        if "=>" in line:
            istart = line.find("=>") + 3
            iend = line.rfind("(")
            yield line[istart:iend-1].strip()


def list_dependencies(executable):
    for lib in list_libraries(executable):
        if lib.startswith("/c/"):
            continue
        if not "/" in lib:
            continue
        yield lib
        

def create_runner(executable_name, script_file):
    with open(script_file, "w") as f:
        f.write("@echo off\r\n")
        f.write("SET OME_HOME=%~dp0\\mingw64\r\n")
        f.write("%~dp0\\" + executable_name + " %*\r\n")


if not os.path.exists(package_path):
    os.mkdir(package_path)
    
# Copy shared paths
for path in shared_paths:
    if not os.path.exists(package_path + "/" + path):
        shutil.copytree(cygpath(path), package_path + "/" + path)
    
# Copy applications	
for app in applications:
    print("Packaging application " + app)

    # Copy the application
    shutil.copy(cygpath(which(app)), package_path)

    # Copy dependency libraries
    for lib in list_dependencies(which(app)):
        lib_path = cygpath(lib)
        if os.path.exists(lib_path) and not os.path.exists(package_path + "/" + os.path.basename(lib_path)):
            print("Copying " + lib)
            shutil.copy(lib_path, package_path)
            
    # Create a runner *.bat (necessary for OME)
    create_runner(app, package_path + "/" + os.path.splitext(app)[0] + ".bat")
    

