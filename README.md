# Mesa-LLVM
Script for installing Mesa-git and LLVM-git on Ubuntu and Debian based distros.

# ATTENTION
DON'T use mesa PPAs (oibaf, kisak, padoka, etc.) nor update from update manager. This will roll you back to llvm-stable




# Running the script
I recommend using `bash <(curl -s https://raw.githubusercontent.com/C1fer/Mesa-LLVM/master/mesa-llvm.sh)` since it will always use the latest version of, but you can download and run it using `./mesa-llvm.sh`.



# Speed up compilation
You can use ccache to make the compilation go much faster. In order to setup ccache, type the following commands on a terminal window:
```
sudo apt install -y ccache
echo 'export PATH="/usr/lib/ccache:$PATH"' | sudo tee -a ~/.bashrc
sudo /usr/sbin/update-ccache-symlinks
```
