#!/usr/bin/env bash
echo "Stopping all services"
sudo systemctl stop phenix-web

echo "Deleting existing bridges"
sudo ovs-vsctl del-br mega_bridge
sudo ovs-vsctl del-br phenix

echo "Disabling existing services"
sudo systemctl disable phenix-web.service
sudo systemctl disable miniweb.service
sudo systemctl disable minimega.service

echo "Cleaning up existing installation in /opt"
sudo rm -f /opt/build.tar.xz
sudo rm -rf /opt/build
sudo rm -rf /opt/phenix
sudo rm -rf /opt/minimega

echo "Cleaning up yarn, gvm, npm, and nvm"
sudo dpkg -r yarn
sudo rm -rf $HOME/offline-node-modules
sudo rm -rf $HOME/.gvm
sudo rm -rf $HOME/.npm
sudo rm -rf $HOME/.nvm
sudo rm -rf /usr/lib/node_modules
sudo rm -rf $HOME/.yarn
sudo rm -rf $HOME/.cache/go-build
sudo rm -rf /usr/local/go
sudo rm -rf $HOME/.cache/yarn

# Restore the .bashrc file
echo "Restoring .bashrc"
rm -f $HOME/.bashrc
sudo cp /etc/skel/.bashrc $HOME
sudo chown $USER:$USER $HOME/.bashrc

echo "Extracting /opt/build.tar.xz to /opt"
sudo cp build.tar.xz /opt
sudo tar -xJf /opt/build.tar.xz -C /opt
sudo chown -R $USER:$USER /opt/build

# Unpack the go repo
echo "Extracting golang repository"
tar -xJf /opt/build/go.tar.xz -C /opt/build

#Get some helper tools ((not required but makes dealing with multiple go versions easier) 
echo "Installing GVM"
chmod +x /opt/build/gvm/scripts/*
chmod +x /opt/build/gvm/binscripts/*
chmod +x /opt/build/gvm/bin/*
cd /opt/build/gvm
binscripts/gvm-installer
source ~/.gvm/scripts/gvm
cp /opt/build/go1.4.linux-amd64.tar.gz ~/.gvm/archive
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT

#go 1.14 to build minimega, point to local go repository
echo "Installing go 1.14"
gvm install go1.14 -s=/opt/build/go

#go 1.18 to build phenix, point to local go repository
echo "Installing go 1.18"
gvm install go1.18 -s=/opt/build/go

# NVM Manager ( not required but makes dealing with npm easier)
echo "Installing NVM"
chmod +x /opt/build/nvm/*.sh  
# Run the modified install script that points to a local
# git repository
/opt/build/nvm/install.sh 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install nodejs 14.2
mkdir -p $HOME/.nvm/.cache/bin
cp /opt/build/node-v14.2.0-linux-x64.tar.xz $HOME/.nvm/.cache/bin
mkdir -p $HOME/.nvm/versions/node
tar -xJf /opt/build/node-v14.2.0-linux-x64.tar.xz -C $HOME/.nvm/versions/node
mv $HOME/.nvm/versions/node/node-v14.2.0-linux-x64 $HOME/.nvm/versions/node/v14.2.0
chmod +x $HOME/.nvm/versions/node/v14.2.0/bin/*
echo "export PATH=$PATH:$HOME/.nvm/versions/node/v14.2.0/bin" >> $HOME/.bashrc
echo "export SASS_BINARY_PATH=$HOME/offline-node-modules/linux-x64-83_binding.node" >> $HOME/.bashrc
source $HOME/.bashrc

# Add redoc-cli to the path
echo "export PATH=/opt/phenix/src/js/node_modules/.bin:$PATH" >> $HOME/.bashrc

# Install yarn
echo "Installing yarn"
sudo dpkg -i /opt/build/yarn_1.22.17_all.deb

# Setup the offline mirror
tar -xJf /opt/build/offline-node-modules.tar.xz -C $HOME/
sudo chown -R $USER:$USER $HOME/offline-node-modules
yarn config set yarn-offline-mirror $HOME/offline-node-modules
yarn config set yarn-offline-mirror-pruning true

# Install google proto buffers
echo "Installing Google proto buffers"
PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip
sudo unzip -o /opt/build/$PROTOC_ZIP -d /usr/local bin/protoc
sudo unzip -o /opt/build/$PROTOC_ZIP -d /usr/local 'include/*'

#setup image directory
sudo mkdir -p /phenix/images
sudo chown -R $USER:$USER /phenix/images

#setup minimega
echo "Setting up minimega"
sudo tar -xJf /opt/build/minimega.tar.xz -C /opt
sudo cp /opt/build/services/mini*.service /opt/minimega
sed -i s/MM_CONTEXT=minimega/MM_CONTEXT=$(hostname -s)/ /opt/minimega/minimega.service
sudo chown -R $USER:$USER /opt/minimega
cd /opt/minimega/scripts;
gvm use go1.14;
./build.bash

#setup phenix
echo "Setting up phenix"
sudo tar -xJf /opt/build/phenix.tar.xz -C /opt
sudo cp /opt/build/services/phenix*.service /opt/phenix
sudo chown -R $USER:$USER /opt/phenix
YARNRC=$(yarn config list --verbose | grep Found | grep yarn | grep -Po '["]([^"]+)["]' | head -n1 | sed s/\"//g)
mv $YARNRC /opt/phenix/src/js
cd /opt/phenix;
gvm use go1.18;
make bin/phenix

#setup ovs bridge
sudo ovs-vsctl add-br mega_bridge
sudo ovs-vsctl add-br phenix

#setup services
sudo systemctl enable /opt/phenix/phenix-web.service
sudo systemctl enable /opt/minimega/miniweb.service
sudo systemctl enable /opt/minimega/minimega.service

#start all the services
sudo systemctl start phenix-web

#navigate to host port 3000  
firefox http://localhost:3000 &  
