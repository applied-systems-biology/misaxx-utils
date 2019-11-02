# Windows build for Cygwin

## Building & packaging MISA++

1. Open Cygwin and navigate into the folder that contains this README
2. Run ./build.sh
3. Run ./package.sh

The ./bin folder contains the MISA++ executables, including dependency libraries.
The ./bin/misa-imagej folder contains the ImageJ plugin and its dependencies.
You can install the plugin by merging the folders in ./bin/misa-imagej with
the application folders of a Fiji (https://fiji.sc/) installation.

The ./package.sh script also generates a ./Fiji.app folder that contains a 
ready-to-use Fiji distribution with MISA++. Please **copy** this folder somewhere else
to allow correct execution. The reason behind this is that Cygwin breaks necessary
permissions for *.bat files.

## Common issues 

### ./Fiji.app distribution has no MISA++ applications in the list

Please **copy** the folder to some other location to fix the filesystem 
permissions.

### A download fails

We cannot prevent URLs from invalidating if software authors change servers.
Please update the URLs to the new location if such issues arise.