# Mesa-LLVM
Script for installing Mesa-git and LLVM-git on Ubuntu and Debian based distros.

# ATTENTION
DON'T a PPA (Oibaf, Kisak, Padoka, etc.) nor update from Update Manager if you want to use this script. Updating from another source aside from this will roll you back to llvm-stable.

# Usage
In order for the script to work, you need to enable source code repositories and unstable packages on your distro's software sources manager. Note that if you've added a ppa before these options should be enabled. 

I recommend using `bash <(curl -s https://raw.githubusercontent.com/C1fer/Mesa-LLVM/master/mesa-llvm.sh)` for running the script. With that you will always use the latest version, but you can download it and run it using `./mesa-llvm.sh` if you want.

# Speed up compilation
You can use ccache to make the compilation go much faster. In order to set up ccache, type these commands on a teminal window and then log out.
```
sudo apt install -y ccache
echo 'export PATH="/usr/lib/ccache:$PATH"' | sudo tee -a ~/.bashrc
sudo /usr/sbin/update-ccache-symlinks
```
