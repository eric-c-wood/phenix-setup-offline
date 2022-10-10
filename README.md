## phenix-offline package notes
1) Install Ubuntu 18.04 LTS
2) Navigate to the home directory on the Ubuntu 18.04 LTS (e.g. `cd ~`)
3) Install git `sudo apt -y install git`
4) Clone this repository `git clone https://github.com/eric-c-wood/phenix-setup-offline.git`
5) Run `source $HOME/phenix-setup-offline/package_phenix.sh`
6) After the package_phenix.sh script is finished running, there should be a 
/opt/build.tar.xz compressed archive.  
7) Burn the /opt/build.tar.xz archive, the $HOME/phenix-setup-offline/*.sh and the $HOME/phenix-setup-offline/README.md files to a DVD
8) To test, copy all files from the DVD to $HOME on a clean Ubuntu 18.04 LTS
installation.  
9) Run `cd $HOME;source setup_offline.sh`

## phenix-offline update package notes
1) To update from an existing installation, Run 'cd $HOME;source update_offline.sh` for step 9