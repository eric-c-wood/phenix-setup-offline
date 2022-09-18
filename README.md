# phenix-offline-setup
Here are the instructions for using this repository to setup phenix offline
1) Acquire git-lfs `apt install git-lfs`
2) git-lfs clone https://github.com/eric-c-wood/phenix-offline-setup.git
3) change into the `phenix-offline-setup` directory
4) run `source setup_offline.sh`

## phenix-offline package notes
1) Make sure the system is in a clean state (i.e new OS install or clear all caches `yarn cache clean`, `npm cache clean` , etc.)
2) Download all required packages Nodejs 14.2, Yarn 1.22.17, ProtBuf 3.7.1
3) Clone the golang, gvm, npm, phenix, and minimega repositories
4) Modify nvm and gvm to point to local repositories
5) Create the node-sass environment variable `SASS_BINARY_PATH` and point it to the yarn offline mirror (this will download the nodejs binding node to the specified offline mirror)
6) Create a yarn offline mirror
7) Modify the phenix/src/js Makefile for offline installation `yarn install --offline`
8) Change into the phenix/src/go directory and run `go mod vendor` to create a vendor directory with all external dependencies
9) Archive and compress all files to save storage
