

SET(CPACK_GENERATOR "DEB")
SET(CPACK_DEBIAN_PACKAGE_NAME "libome-files")
SET(CPACK_DEBIAN_PACKAGE_VERSION "0.5.0")
SET(CPACK_DEBIAN_PACKAGE_RELEASE "1")
SET(CPACK_DEBIAN_PACKAGE_DESCRIPTION "OME Files library")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "OpenMicroscopy")
SET(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://openmicroscopy.org/")
SET(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
INCLUDE(CPack)
 