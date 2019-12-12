FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
ENV CMAKE_BUILD_SHARED_LIBS ON

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      "file" \
      "build-essential" \
      "gcc-8" \
      "libboost-all-dev" \
      "libxerces-c-dev" \
      "libxalan-c-dev" \
      "libpng-dev" \
      "libtiff5-dev" \
      "python" \
      "unzip" \ 
      "wget" \
      "libopencv-dev" \
      "libsqlite3-dev" \
      "openjdk-8-jdk" \
      "maven" \
      "git" \
      "libcurl4-openssl-dev"
# Required to remove issues with Maven
RUN apt-get remove -y "openjdk-11-jre-headless"
      
##
# Download sources
##

RUN wget --no-check-certificate "https://cmake.org/files/v3.13/cmake-3.13.5.tar.gz" -O /cmake-3.13.5.tar.gz
RUN tar -xvf /cmake-3.13.5.tar.gz

RUN wget --no-check-certificate "https://github.com/nlohmann/json/archive/v3.7.0.zip" -O json-3.7.0.zip
RUN unzip json-3.7.0.zip

RUN wget --no-check-certificate "https://downloads.openmicroscopy.org/ome-common-cpp/5.5.0/source/ome-common-cpp-5.5.0.zip" -O /ome-common-cpp-5.5.0.zip
RUN unzip /ome-common-cpp-5.5.0.zip
 
RUN wget --no-check-certificate "https://downloads.openmicroscopy.org/ome-model/5.6.0/source/ome-model-5.6.0.zip" -O /ome-model-5.6.0.zip
RUN unzip /ome-model-5.6.0.zip

RUN wget --no-check-certificate "https://downloads.openmicroscopy.org/ome-files-cpp/0.5.0/source/ome-files-cpp-0.5.0.zip" -O /ome-files-cpp-0.5.0.zip
RUN unzip /ome-files-cpp-0.5.0.zip

RUN git clone https://github.com/applied-systems-biology/misaxx-core.git && cd misaxx-core && git pull
RUN git clone https://github.com/applied-systems-biology/misaxx-imaging.git && cd misaxx-imaging && git pull
RUN git clone https://github.com/applied-systems-biology/misaxx-microbench.git && cd misaxx-microbench && git pull
RUN git clone https://github.com/applied-systems-biology/misaxx-deconvolve.git && cd misaxx-deconvolve && git pull
RUN git clone https://github.com/applied-systems-biology/misaxx-segment-cells.git && cd misaxx-segment-cells && git pull
RUN git clone https://github.com/applied-systems-biology/misaxx-ome.git && cd misaxx-ome && git pull
RUN git clone https://github.com/applied-systems-biology/misaxx-ome-visualizer.git && cd misaxx-ome-visualizer && git pull
RUN git clone https://github.com/applied-systems-biology/misaxx-tissue.git && cd misaxx-tissue && git pull
RUN git clone https://github.com/applied-systems-biology/misaxx-kidney-glomeruli.git && cd misaxx-kidney-glomeruli && git pull
RUN git clone https://github.com/applied-systems-biology/misaxx-analyzer.git && cd misaxx-analyzer && git pull
RUN git clone https://github.com/applied-systems-biology/misa-imagej.git && cd misa-imagej && git pull

##
# Setup output directory that contains the *.deb files
##

RUN mkdir /results

##
# Build CMake
##

RUN cd cmake-3.13.5 && ./bootstrap --system-curl && make -j4 && make install

##
# Build NLohmann-JSON
##

RUN mkdir json-3.7.0/build
RUN cd json-3.7.0/build && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4 && make install

##
# Build OME dependency
##

# Build OME Commons DEB package
RUN mkdir ome-common-cpp-5.5.0/build
COPY ome-common-cpack.cmake /ome-common-cpp-5.5.0/ome-common-cpack.cmake
RUN cd ome-common-cpp-5.5.0 && cat ome-common-cpack.cmake >> CMakeLists.txt
RUN cd ome-common-cpp-5.5.0/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd ome-common-cpp-5.5.0/build && cpack
RUN dpkg -i /ome-common-cpp-5.5.0/build/*.deb
RUN cp /ome-common-cpp-5.5.0/build/*.deb /results

# Build OME Model DEB package
RUN mkdir ome-model-5.6.0/build
COPY ome-model-cpack.cmake /ome-model-5.6.0/ome-model-cpack.cmake
RUN cd ome-model-5.6.0 && cat ome-model-cpack.cmake >> CMakeLists.txt
RUN cd ome-model-5.6.0/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd ome-model-5.6.0/build && cpack
RUN dpkg -i /ome-model-5.6.0/build/*.deb
RUN cp /ome-model-5.6.0/build/*.deb /results

# Build OME Files DEB package
RUN mkdir ome-files-cpp-0.5.0/build
COPY ome-files-cpack.cmake /ome-files-cpp-0.5.0/ome-files-cpack.cmake
RUN cd ome-files-cpp-0.5.0 && sed -i "s/return()/#return()/g" CMakeLists.txt
RUN cd ome-files-cpp-0.5.0 && cat ome-files-cpack.cmake >> CMakeLists.txt
RUN cd ome-files-cpp-0.5.0/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd ome-files-cpp-0.5.0/build && cpack
RUN dpkg -i /ome-files-cpp-0.5.0/build/*.deb
RUN cp /ome-files-cpp-0.5.0/build/*.deb /results

##
# Build MISA++ libraries
##

RUN mkdir misaxx-core/build
RUN cd misaxx-core/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-core/build && cpack
RUN dpkg -i /misaxx-core/build/*.deb
RUN cp /misaxx-core/build/*.deb /results

RUN mkdir misaxx-analyzer/build
RUN cd misaxx-analyzer/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-analyzer/build && cpack
RUN dpkg -i /misaxx-analyzer/build/*.deb
RUN cp /misaxx-analyzer/build/*.deb /results

RUN mkdir misaxx-imaging/build
RUN cd misaxx-imaging/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-imaging/build && cpack
RUN dpkg -i /misaxx-imaging/build/*.deb
RUN cp /misaxx-imaging/build/*.deb /results

RUN mkdir misaxx-microbench/build
RUN cd misaxx-microbench/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-microbench/build && cpack
RUN dpkg -i /misaxx-microbench/build/*.deb
RUN cp /misaxx-microbench/build/*.deb /results

RUN mkdir misaxx-deconvolve/build
RUN cd misaxx-deconvolve/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-deconvolve/build && cpack
RUN dpkg -i /misaxx-deconvolve/build/*.deb
RUN cp /misaxx-deconvolve/build/*.deb /results

RUN mkdir misaxx-segment-cells/build
RUN cd misaxx-segment-cells/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-segment-cells/build && cpack
RUN dpkg -i /misaxx-segment-cells/build/*.deb
RUN cp /misaxx-segment-cells/build/*.deb /results

RUN mkdir misaxx-ome/build
RUN cd misaxx-ome/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-ome/build && cpack
RUN dpkg -i /misaxx-ome/build/*.deb
RUN cp /misaxx-ome/build/*.deb /results

RUN mkdir misaxx-ome-visualizer/build
RUN cd misaxx-ome-visualizer/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-ome-visualizer/build && cpack
RUN dpkg -i /misaxx-ome-visualizer/build/*.deb
RUN cp /misaxx-ome-visualizer/build/*.deb /results

RUN mkdir misaxx-tissue/build
RUN cd misaxx-tissue/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-tissue/build && cpack
RUN dpkg -i /misaxx-tissue/build/*.deb
RUN cp /misaxx-tissue/build/*.deb /results

RUN mkdir misaxx-kidney-glomeruli/build
RUN cd misaxx-kidney-glomeruli/build && cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make -j4
RUN cd misaxx-kidney-glomeruli/build && cpack
RUN dpkg -i /misaxx-kidney-glomeruli/build/*.deb
RUN cp /misaxx-kidney-glomeruli/build/*.deb /results

##
# Build MISA++ ImageJ plugin
##

RUN cd misa-imagej && mvn compile && mvn package
RUN cd misa-imagej/target/dependencies && wget --no-check-certificate "http://maven.imagej.net/content/groups/public/org/jfree/jfreesvg/3.3/jfreesvg-3.3.jar"
RUN mkdir -p /results/misa-imagej/jars
RUN mkdir -p /results/misa-imagej/plugins
RUN cp misa-imagej/target/misa_imagej-*.jar /results/misa-imagej/plugins

# Copy dependencies
RUN cp misa-imagej/target/dependencies/autolink*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/flexmark*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/graphics2d*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/jfreesvg*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/openhtmltopdf*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/pdfbox*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/poi*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/sqlite*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/bcprov-jdk15on*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/bcpkix-jdk15on*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/icepdf*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/commons-exec*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/xmlbeans*.jar /results/misa-imagej/jars \
    && cp misa-imagej/target/dependencies/commons-collections4*.jar /results/misa-imagej/jars

## 
# Package results
##
RUN cd /results && tar -czvf /results.tar.gz *
