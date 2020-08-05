# Mesa-LLVM
Script for installing Mesa-git and LLVM-git on Ubuntu and Debian based distros.

# Running the script
I recommend using `bash <(curl -s https://raw.githubusercontent.com/Cifer025/Mesa-LLVM/master/mesa-llvm.sh)` since it will always use the latest version of the
script, but you can download and run it using `./mesa-llvm.sh` on the folder where the file is located.



# Speed up compilation
You can use ccache to make the compilation go much faster. In order to setup ccache, type the following commands on a terminal window:
```
sudo apt install -y ccache
echo 'export PATH="/usr/lib/ccache:$PATH"' | sudo tee -a ~/.bashrc
sudo /usr/sbin/update-ccache-symlinks
```

