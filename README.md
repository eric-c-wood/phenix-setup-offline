## phenix-offline package notes
1) Install Ubuntu 18.04 LTS
2) Change into the home directory on Ubuntu 18.04 LTS by running `cd $HOME`
3) Install git `sudo apt -y install git`
4) Clone this repository `git clone https://github.com/eric-c-wood/phenix-setup-offline.git`
5) Run `source $HOME/phenix-setup-offline/package_phenix.sh`
6) After the package_phenix.sh script is finished running, there should be a 
/opt/build.tar.xz compressed archive. (Note:**The script might take up to 15 minutes to run depending on downstream Internet connection speed and hard drive write speed**)
7) Burn the `/opt/build.tar.xz` archive, the `/opt/*.sh` and the `/opt/README.md` files to a DVD
8) To test, copy all files from the DVD to $HOME on a clean Ubuntu 18.04 LTS
installation.  
9) Run `cd $HOME;source setup_offline.sh`
10) When you see `Installing GVM`, disconnect from the Internet.  A connection to the Internet is initially needed to acquire all the packages from an online package repository.  After the packages are acquired, we disconnect from the Internet to prevent any package manager from trying to use the Internet to install a Javascript library if one can not be found locally.  Since the purpose of the test is to verify that installation will succeed when not connected to the Internet, disconnecting from the Internet helps to maintain the parameters of the test.

## phenix-offline update package notes
1) To update from an existing installation, Run `cd $HOME;source update_offline.sh` for step 9.  If testing the `update_offline.sh` script, no connection to the Internet should be available and an existing installation of Phenix/Minimega should exist.
