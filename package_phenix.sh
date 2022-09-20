#!/usr/bin/env bash

# Ubuntu 18.04 LTS Phenix Offline Package Creation
# Make sure the system is in a clean state (i.e new OS install, or clear all caches 'yarn cache clean', 'npm cache clean', etc.)

# Create a package directory and switch into it
echo "Creating package directory"
sudo mkdir -p /opt/build;chown -R $USER:$USER;cd /opt/build

# Download Nodejs 14.2
echo "Downloading Nodejs 14.2"
wget https://nodejs.org/download/release/v14.2.0/node-v14.2.0-linux-x64.tar.xz

# Download yarn 1.22.17
echo "Downloading yarn 1.22.17"
wget https://github.com/yarnpkg/yarn/releases/download/v1.22.17/yarn_1.22.17_all.deb

# Download Protobuf 3.7.1 
echo "Downloading Protobuf 3.7.1"
wget https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-x86_64.zip

# install git
echo "Installing git"
sudo apt -y install git

# Clone the golang repository
echo "Cloning Golang repository"
git clone https://github.com/golang/go.git

# Download go1.4 
echo "Downloading go1.4"
wget https://go.dev/dl/go1.4.linux-amd64.tar.gz

# Clone the gvm repository 
echo "Cloning gvm repository"
git clone https://github.com/moovweb/gvm.git

# Clone the nvm repository 
echo "Cloning nvm repository"
git clone https://github.com/nvm-sh/nvm.git

# Clone the minimega repository 
echo "Cloning minimega repository"
git clone https://github.com/sandia-minimega/minimega.git

# Clone the phenix repository
echo "Cloning phenix repository"
git clone https://github.com/sandia-minimega/phenix.git

########### Setup yarn offline mirror ###############

# Install google proto buffers
echo "Installing Google proto buffers"
PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip
sudo unzip -o /opt/build/$PROTOC_ZIP -d /usr/local bin/protoc
sudo unzip -o /opt/build/$PROTOC_ZIP -d /usr/local 'include/*'

# Install nodejs 14.2
sudo apt -y install curl
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt -y install nodejs

# Install yarn
echo "Installing yarn"
sudo dpkg -i /opt/build/yarn_1.22.17_all.deb

# Create the SASS_BINARY_PATH environment variable to download
# the nodejs binding node
echo "export SASS_BINARY_PATH=$HOME/offline-node-modules/linux-x64-83_binding.node" >> $HOME/.bashrc
source $HOME/.bashrc

# Point yarn to offline mirror
yarn config set yarn-offline-mirror $HOME/offline-node-modules
yarn config set yarn-offline-mirror-pruning true
mv $HOME/.yarnrc /opt/build/phenix/src/js

# Install go1.18 for Phenix to obtain libraries for offline use
wget https://go.dev/dl/go1.18.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf /opt/build/go1.18.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# Create vendor directories and download the external libraries
cd /opt/build/phenix/src/go;go mod vendor;

# Build phenix which will acquire all the required libraries
# for offline use
sudo apt -y install make
sudo chown -R $USER:$USER /opt/build/phenix
cd /opt/build/phenix;make bin/phenix;
cd /opt/build

############ End Offline Mirror Setup ###################

# Modify the phenix/src/js Makefile for offline 
sed -i 's/yarn install/yarn install --offline/g' /opt/build/phenix/src/js/Makefile

# Modify nvm install to point to a local repository
sed -i 's|https://github.com/${NVM_GITHUB_REPO}.git|/opt/build/nvm|g' /opt/build/nvm/install.sh

# Download the nodejs binding node 
#echo "Downloading nodejs binding node"
#wget https://github.com/sass/node-sass/releases/download/v7.0.1/linux-#x64-83_binding.node

# Download redoc-cli 13.8 
echo "Downloading redoc-cli 13.8"
wget https://registry.npmjs.org/redoc-cli/-/redoc-cli-0.13.8.tgz

# Create the golang archive 
echo "Creating the Golang archive"
tar -cJv -f /opt/build/go.tar.xz /opt/build/go/

# Create the minimega archive 
echo "Creating the minimega archive"
tar -cJv -f /opt/build/minimega.tar.xz /opt/build/minimega/

# Create the phenix archive 
echo "Creating the phenix archive"
rm -rf /opt/build/phenix/src/js/dist
rm -rf /opt/build/phenix/src/js/node_modules
rm -rf /opt/build/phenix/bin
tar -cJv -f /opt/build/phenix.tar.xz /opt/build/phenix/

# Download the services 
echo "Downloading the phenix and minimega services"
git clone https://github.com/eric-c-wood/phenix-setup-offline.git
mkdir -p /opt/build/services
cp /opt/build/phenix-setup-offline/*.service /opt/build/services

# Create the offline-node-modules archive
echo "Creating offline-node-modules archive"
tar -cJv -f /opt/build/offline-node-modules.tar.xz $HOME/offline-node-modules

# Create the build archive

# Remove files that are no longer needed
rm -rf /opt/build/phenix-setup-offline
rm -f /opt/build/go1.18.linux-amd64.tar.gz
rm -rf /opt/build/phenix
rm -rf /opt/build/minimega
rm -rf /opt/build/go

cd /opt
sudo tar -cJv -f /opt/build.tar.xz /opt/build




