## phenix-offline package notes
1) Install Ubuntu 18.04 LTS
2) Change into the home directory on Ubuntu 18.04 LTS by running `cd $HOME`
3) Install git `sudo apt -y install git`
4) Clone this repository `git clone https://github.com/eric-c-wood/phenix-setup-offline.git`
5) Run `source $HOME/phenix-setup-offline/package_phenix.sh`
6) After the package_phenix.sh script is finished running, there should be a 
/opt/build.tar.xz compressed archive. (**Note:The script might take up to 15 minutes to run depending on downstream Internet connection speed and hard drive write speed ) **
7) Burn the `/opt/build.tar.xz` archive, the `/opt/*.sh` and the `/opt/README.md` files to a DVD
8) To test, copy all files from the DVD to $HOME on a clean Ubuntu 18.04 LTS
installation.  
9) Run `cd $HOME;source setup_offline.sh`

## phenix-offline update package notes
1) To update from an existing installation, Run `cd $HOME;source update_offline.sh` for step 9
