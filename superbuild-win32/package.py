#!/usr/bin/env python2

# Configuration
applications = [
    "misaxx-analyzer.exe",
    "misaxx-tissue-segmentation.exe",
    "misaxx-kidney-glomeruli-segmentation.exe"
]
package_path = "./package-win32"

# Script
from subprocess import check_output
import sys
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


if not os.path.exists(package_path):
    os.mkdir(package_path)
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

