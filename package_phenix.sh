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
sudo apt install git

# Clone the golang repository
echo "Cloning Golang repository"
git clone https://github.com/golang/go.git

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

# Download go1.4 
echo "Downloading go1.4"
wget https://go.dev/dl/go1.4.linux-amd64.tar.gz

# Modify nvm install to point to a local repository
sed -i 's|https://github.com/${NVM_GITHUB_REPO}.git|/opt/build/nvm|g' nvm/install.sh

# Download the SASS binding node 
echo "Downloading SASS binding node"
wget https://github.com/sass/node-sass/releases/download/v7.0.1/linux-x64-83_binding.node

# Download redoc-cli 13.8 
echo "Downloading redoc-cli 13.8"
wget https://registry.npmjs.org/redoc-cli/-/redoc-cli-0.13.8.tgz

# Create the golang archive 
echo "Creating the Golang archive"
tar -cJv -f go.tar.xz go/

# Create the minimega archive 
echo "Creating the minimega archive"
tar -cJv -f minimega.tar.xz minimega/

# Create the phenix archive 
echo "Creating the phenix archive"
tar -cJv -f phenix.tar.xz phenix/

# Download the services 
echo "Downloading the phenix and minimega services"
git clone https://github.com/eric-c-wood/phenix-setup-offline.git



