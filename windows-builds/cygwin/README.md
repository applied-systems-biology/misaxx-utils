# Windows build for Cygwin

## Prerequisites

Please download Cygwin64 (https://www.cygwin.com/) and install the packages listed
below in the "Cygwin packages" section. 

## Building & packaging MISA++

1. Open Cygwin and navigate into the folder that contains this README
2. Run `dos2unix *.sh`
3. Run `./build.sh`
4. Run `./package.sh`

The ./bin folder contains the MISA++ executables, including dependency libraries.
The ./bin/misa-imagej folder contains the ImageJ plugin and its dependencies.
You can install the plugin by merging the folders in ./bin/misa-imagej with
the application folders of a Fiji (https://fiji.sc/) installation.

The ./package.sh script also generates a ./Fiji.app folder that contains a 
ready-to-use Fiji distribution with MISA++. Please **copy** this folder somewhere else
to allow correct execution. The reason behind this is that Cygwin breaks necessary
permissions for *.bat files.

## Common issues 

### Carriage return (\r) not recognized by Cygwin Bash

Please run `dos2unix *.sh` in the folder that contains this README.
The error is caused by git that automatically converts `\n` line endings
to `\r\n` on Windows.

### ./Fiji.app distribution has no MISA++ applications in the list

Please **copy** the folder to some other location to fix the filesystem 
permissions.

### Downloads fail due to wrong URL

We cannot prevent URLs from invalidating if software authors change servers.
Please update the URLs to the new location if such issues arise.

### Downloads fail due to SSL/GnuTLS issues

This can happen if the virus scanner interferes with the downloading process or in some non-root Cygwin-installations.
A workaround is to download all necessary files manually in a browser and renaming them accordingly.

To do this, open all `install-*` and `build-*` scripts and search for the `download_if_not_exist` lines. This function takes
the URL as first argument and the name of the \*.zip file as second argument.

For example: 
```bash
download_if_not_exist http://apache.mirror.digionline.de/xalan/xalan-c/sources/xalan_c-1.11-src.zip xalan_c
```
In this case download `http://apache.mirror.digionline.de/xalan/xalan-c/sources/xalan_c-1.11-src.zip` manually and rename it 
to `xalan_c`. The build scripts will not attempt to download the zip file and extract them instead.

**Important: ./build-misa-imagej.sh contains an additional download for a missing dependency library that should be placed in ./misa-imagej-master/target/dependencies**

### Zip error

In case of a corrupted zip file, remove it and re-run the build script. See other common problems if the download itself does not work.

## Cygwin packages

You can find a list of all Cygwin packages below.
Execute the Cygwin setup with following parameter to pre-select packages in the list:

```
./setup-x86_64.exe -P _autorebase,dos2unix,adwaita-icon-theme,alternatives,at-spi2-core,autoconf,autoconf2.1,autoconf2.5,automake,automake1.10,automake1.11,automake1.12,automake1.13,automake1.14,automake1.15,automake1.16,automake1.9,base-cygwin,base-files,bash,binutils,boost-build,bzip2,ca-certificates,clang,cmake,compiler-rt,coreutils,crypto-policies,cygutils,cygwin,cygwin-devel,dash,dconf-service,dejavu-fonts,desktop-file-utils,diffutils,dri-drivers,editrights,file,findutils,gamin,gawk,gcc-core,gcc-g++,gdb,gdk-pixbuf2.0-svg,getent,glib2.0-networking,grep,groff,gsettings-desktop-schemas,gtk-update-icon-cache,gzip,hicolor-icon-theme,hostname,info,ipc-utils,iso-codes,less,libarchive13,libargp,libatk-bridge2.0_0,libatk1.0_0,libatomic1,libatspi0,libattr1,libblkid1,libboost-devel,libboost_atomic1.66,libboost_chrono1.66,libboost_container1.66,libboost_context1.66,libboost_coroutine1.66,libboost_date_time1.66,libboost_filesystem1.66,libboost_graph1.66,libboost_iostreams1.66,libboost_locale1.66,libboost_log1.66,libboost_math1.66,libboost_program_options1.66,libboost_random1.66,libboost_regex1.66,libboost_serialization1.66,libboost_signals1.66,libboost_stacktrace1.66,libboost_system1.66,libboost_test1.66,libboost_thread1.66,libboost_timer1.66,libboost_type_erasure1.66,libboost_wave1.66,libbrotlicommon1,libbrotlidec1,libbz2_1,libc++-devel,libc++1,libc++abi-devel,libc++abi1,libcairo2,libclang8,libcom_err2,libcroco0.6_3,libcrypt0,libcrypt2,libcurl4,libdatrie1,libdb5.3,libdbus1_3,libedit0,libepoxy0,libexpat1,libfam0,libfdisk1,libffi6,libfontconfig-common,libfontconfig1,libfreetype6,libgc1,libgcc1,libgdbm4,libgdbm6,libgdbm_compat4,libgdk_pixbuf2.0_0,libGL1,libglapi0,libglib2.0_0,libgmp10,libgnutls30,libgomp1,libgraphite2_3,libgssapi_krb5_2,libgstinterfaces1.0_0,libgstreamer1.0_0,libgtk3_0,libguile2.0_22,libharfbuzz0,libhdf5_10,libhogweed4,libhwloc15,libiconv,libiconv2,libicu-devel,libicu61,libicu65,libidn2_0,libilmbase12,libIlmImf22,libintl8,libisl15,libjasper4,libjbig2,libjpeg8,libjson-glib1.0_0,libjsoncpp19,libk5crypto3,libkrb5_3,libkrb5support0,libllvm8,libltdl7,liblz4_1,liblzma5,liblzo2_2,libmpc3,libmpfr6,libncursesw10,libnettle6,libnghttp2_14,libnsl2,libOpenCL1,libopencv-devel,libopencv3.2,libopenldap2_4_2,liborc0.4_0,libp11-kit0,libpango1.0_0,libpcre1,libpipeline1,libpixman1_0,libpkgconf3,libpng16,libpng16-devel,libpocl-common,libpocl2,libpolly8,libpopt-common,libpopt0,libproxy1,libpsl5,libquadmath0,libreadline7,librest0.7_0,librhash0,librsvg2_2,libsasl2_3,libsigsegv2,libsmartcols1,libsoup-gnome2.4_1,libsoup2.4_1,libsqlite3-devel,libsqlite3_0,libssh-common,libssh4,libssl1.0,libssl1.1,libstdc++6,libtasn1_6,libthai0,libtiff-devel,libtiff6,libtirpc-common,libtirpc3,libunistring2,libunwind-devel,libunwind1,libuuid-devel,libuuid1,libuv1,libwebp5,libwebp7,libX11-xcb1,libX11_6,libXau6,libxcb-glx0,libxcb-render0,libxcb-shm0,libxcb1,libXcomposite1,libXcursor1,libXdamage1,libXdmcp6,libxerces-c-devel,libxerces-c31,libXext6,libXfixes3,libXft2,libXi6,libXinerama1,libxml2,libXrandr2,libXrender1,libXtst6,login,m4,make,man-db,mintty,ncurses,opencv,openssl,p11-kit,p11-kit-trust,patch,perl,perl-Test-Harness,perl-Unicode-Normalize,perl_autorebase,perl_base,pkg-config,pkgconf,publicsuffix-list-dafsa,python-pip-wheel,python-setuptools-wheel,python2,python27,python3,python36,rebase,run,sed,shared-mime-info,sqlite3,sqlite3-vfslog,tar,terminfo,terminfo-extra,texinfo,tzcode,tzdata,unzip,util-linux,vim-minimal,w32api-headers,w32api-runtime,wget,which,windows-default-manifest,xz,zip,zlib-devel,zlib0

```

```
Package                      Version
_autorebase                  001007-1
dos2unix                     7.4.1
adwaita-icon-theme           3.26.1-1
alternatives                 1.3.30c-10
at-spi2-core                 2.26.2-1
autoconf                     13-1
autoconf2.1                  2.13-12
autoconf2.5                  2.69-4
automake                     11-1
automake1.10                 1.10.3-3
automake1.11                 1.11.6-3
automake1.12                 1.12.6-3
automake1.13                 1.13.4-2
automake1.14                 1.14.1-3
automake1.15                 1.15.1-2
automake1.16                 1.16.1-1
automake1.9                  1.9.6-11
base-cygwin                  3.8-1
base-files                   4.3-2
bash                         4.4.12-3
binutils                     2.29-1
boost-build                  1.66.0-1
bzip2                        1.0.8-1
ca-certificates              2.32-1
clang                        8.0.1-1
cmake                        3.14.5-1
compiler-rt                  8.0.1-1
coreutils                    8.26-2
crypto-policies              20190218-1
cygutils                     1.4.16-2
cygwin                       3.0.7-1
cygwin-devel                 3.0.7-1
dash                         0.5.9.1-1
dconf-service                0.26.1-1
dejavu-fonts                 2.37-1
desktop-file-utils           0.23-1
diffutils                    3.5-2
dri-drivers                  19.1.6-1
editrights                   1.03-1
file                         5.32-1
findutils                    4.6.0-1
gamin                        0.1.10-15
gawk                         5.0.1-1
gcc-core                     8.3.0-1
gcc-g++                      8.3.0-1
gdb                          8.1.1-1
gdk-pixbuf2.0-svg            2.40.20-1
getent                       2.18.90-4
glib2.0-networking           2.54.1-1
grep                         3.0-2
groff                        1.22.4-1
gsettings-desktop-schemas    3.24.1-1
gtk-update-icon-cache        3.22.28-1
gzip                         1.8-1
hicolor-icon-theme           0.15-1
hostname                     3.13-1
info                         6.7-1
ipc-utils                    1.0-2
iso-codes                    4.3-1
less                         530-1
libarchive13                 3.3.2-1
libargp                      20110921-3
libatk-bridge2.0_0           2.26.1-1
libatk1.0_0                  2.26.1-1
libatomic1                   7.4.0-1
libatspi0                    2.26.2-1
libattr1                     2.4.48-2
libblkid1                    2.33.1-1
libboost-devel               1.66.0-1
libboost_atomic1.66          1.66.0-1
libboost_chrono1.66          1.66.0-1
libboost_container1.66       1.66.0-1
libboost_context1.66         1.66.0-1
libboost_coroutine1.66       1.66.0-1
libboost_date_time1.66       1.66.0-1
libboost_filesystem1.66      1.66.0-1
libboost_graph1.66           1.66.0-1
libboost_iostreams1.66       1.66.0-1
libboost_locale1.66          1.66.0-1
libboost_log1.66             1.66.0-1
libboost_math1.66            1.66.0-1
libboost_program_options1.66 1.66.0-1
libboost_random1.66          1.66.0-1
libboost_regex1.66           1.66.0-1
libboost_serialization1.66   1.66.0-1
libboost_signals1.66         1.66.0-1
libboost_stacktrace1.66      1.66.0-1
libboost_system1.66          1.66.0-1
libboost_test1.66            1.66.0-1
libboost_thread1.66          1.66.0-1
libboost_timer1.66           1.66.0-1
libboost_type_erasure1.66    1.66.0-1
libboost_wave1.66            1.66.0-1
libbrotlicommon1             1.0.7-1
libbrotlidec1                1.0.7-1
libbz2_1                     1.0.8-1
libc++-devel                 8.0.1-1
libc++1                      8.0.1-1
libc++abi-devel              8.0.1-1
libc++abi1                   8.0.1-1
libcairo2                    1.16.0-1
libclang8                    8.0.1-1
libcom_err2                  1.44.5-1
libcroco0.6_3                0.6.12-1
libcrypt0                    2.1-1
libcrypt2                    4.4.4-1
libcurl4                     7.66.0-1
libdatrie1                   0.2.8-1
libdb5.3                     5.3.28-2
libdbus1_3                   1.10.22-1
libedit0                     20130712-1
libepoxy0                    1.4.3-1
libexpat1                    2.2.6-1
libfam0                      0.1.10-15
libfdisk1                    2.33.1-1
libffi6                      3.2.1-2
libfontconfig-common         2.13.1-1
libfontconfig1               2.13.1-1
libfreetype6                 2.9.1-1
libgc1                       8.0.4-1
libgcc1                      8.3.0-1
libgdbm4                     1.13-1
libgdbm6                     1.18.1-1
libgdbm_compat4              1.18.1-1
libgdk_pixbuf2.0_0           2.36.11-1
libGL1                       19.1.6-1
libglapi0                    19.1.6-1
libglib2.0_0                 2.54.3-1
libgmp10                     6.1.2-1
libgnutls30                  3.6.9-1
libgomp1                     7.4.0-1
libgraphite2_3               1.3.10-1
libgssapi_krb5_2             1.15.2-2
libgstinterfaces1.0_0        1.12.5-1
libgstreamer1.0_0            1.12.5-1
libgtk3_0                    3.22.28-1
libguile2.0_22               2.0.14-3
libharfbuzz0                 2.5.3-1
libhdf5_10                   1.8.20-1
libhogweed4                  3.4.1-1
libhwloc15                   2.0.3-1
libiconv                     1.14-3
libiconv2                    1.14-3
libicu-devel                 65.1-1
libicu61                     61.1-1
libicu65                     65.1-1
libidn2_0                    2.2.0-1
libilmbase12                 2.2.0-1
libIlmImf22                  2.2.0-1
libintl8                     0.19.8.1-2
libisl15                     0.16.1-1
libjasper4                   2.0.14-1
libjbig2                     2.0-14
libjpeg8                     1.5.3-1
libjson-glib1.0_0            1.4.2-1
libjsoncpp19                 1.8.4-1
libk5crypto3                 1.15.2-2
libkrb5_3                    1.15.2-2
libkrb5support0              1.15.2-2
libllvm8                     8.0.1-1
libltdl7                     2.4.6-7
liblz4_1                     1.7.5-1
liblzma5                     5.2.4-1
liblzo2_2                    2.10-1
libmpc3                      1.1.0-1
libmpfr6                     4.0.2-1
libncursesw10                6.1-1.20190727
libnettle6                   3.4.1-1
libnghttp2_14                1.37.0-1
libnsl2                      1.2.0-1
libOpenCL1                   2.2.12-1
libopencv-devel              3.2.0-2
libopencv3.2                 3.2.0-2
libopenldap2_4_2             2.4.48-1
liborc0.4_0                  0.4.28-1
libp11-kit0                  0.23.15-1
libpango1.0_0                1.40.14-1
libpcre1                     8.43-1
libpipeline1                 1.5.1-1
libpixman1_0                 0.38.4-1
libpkgconf3                  1.6.0-1
libpng16                     1.6.37-1
libpng16-devel               1.6.37-1
libpocl-common               1.3-1
libpocl2                     1.3-1
libpolly8                    8.0.1-1
libpopt-common               1.16-2
libpopt0                     1.16-2
libproxy1                    0.4.14-2
libpsl5                      0.21.0-1
libquadmath0                 7.4.0-1
libreadline7                 7.0.3-3
librest0.7_0                 0.8.1-1
librhash0                    1.3.7-1
librsvg2_2                   2.40.20-1
libsasl2_3                   2.1.26-11
libsigsegv2                  2.10-2
libsmartcols1                2.33.1-1
libsoup-gnome2.4_1           2.60.3-1
libsoup2.4_1                 2.60.3-1
libsqlite3-devel             3.30.0-1
libsqlite3_0                 3.30.0-1
libssh-common                0.8.7-1
libssh4                      0.8.7-1
libssl1.0                    1.0.2t-1
libssl1.1                    1.1.1d-1
libstdc++6                   7.4.0-1
libtasn1_6                   4.14-1
libthai0                     0.1.26-1
libtiff-devel                4.0.9-1
libtiff6                     4.0.9-1
libtirpc-common              1.1.4-1
libtirpc3                    1.1.4-1
libunistring2                0.9.10-1
libunwind-devel              8.0.1-1
libunwind1                   8.0.1-1
libuuid-devel                2.33.1-1
libuuid1                     2.33.1-1
libuv1                       1.32.0-1
libwebp5                     0.4.4-1
libwebp7                     0.6.1-2
libX11-xcb1                  1.6.8-1
libX11_6                     1.6.8-1
libXau6                      1.0.9-1
libxcb-glx0                  1.13-1
libxcb-render0               1.13-1
libxcb-shm0                  1.13-1
libxcb1                      1.13-1
libXcomposite1               0.4.5-1
libXcursor1                  1.2.0-1
libXdamage1                  1.1.5-1
libXdmcp6                    1.1.3-1
libxerces-c-devel            3.1.4-1
libxerces-c31                3.1.4-1
libXext6                     1.3.4-1
libXfixes3                   5.0.3-1
libXft2                      2.3.3-1
libXi6                       1.7.10-1
libXinerama1                 1.1.4-1
libxml2                      2.9.9-2
libXrandr2                   1.5.2-1
libXrender1                  0.9.9-1
libXtst6                     1.2.3-1
login                        1.13-1
m4                           1.4.18-1
make                         4.2.1-2
man-db                       2.7.6.1-1
mintty                       3.0.6-1
ncurses                      6.1-1.20190727
opencv                       3.2.0-2
openssl                      1.1.1d-1
p11-kit                      0.23.15-1
p11-kit-trust                0.23.15-1
patch                        2.7.4-1
perl                         5.26.3-2
perl-Test-Harness            3.42-1
perl-Unicode-Normalize       1.26-1
perl_autorebase              5.26.3-2
perl_base                    5.26.3-2
pkg-config                   1.6.0-1
pkgconf                      1.6.0-1
publicsuffix-list-dafsa      20190717-1
python-pip-wheel             19.2.3-1
python-setuptools-wheel      41.2.0-1
python2                      2.7.16-1
python27                     2.7.16-1
python3                      3.6.8-1
python36                     3.6.9-1
rebase                       4.4.4-1
run                          1.3.4-2
sed                          4.4-1
shared-mime-info             1.8-1
sqlite3                      3.30.0-1
sqlite3-vfslog               3.30.0-1
tar                          1.29-1
terminfo                     6.1-1.20190727
terminfo-extra               6.1-1.20190727
texinfo                      6.7-1
tzcode                       2019c-1
tzdata                       2019c-1
unzip                        6.0-17
util-linux                   2.33.1-1
vim-minimal                  8.1.1772-1
w32api-headers               5.0.4-1
w32api-runtime               5.0.4-1
wget                         1.19.1-2
which                        2.20-2
windows-default-manifest     6.4-1
xz                           5.2.4-1
zip                          3.0-12
zlib-devel                   1.2.11-1
zlib0                        1.2.11-1
```
