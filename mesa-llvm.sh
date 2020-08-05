#!/bin/bash
mkdir /tmp/mesa-llvm && cd /tmp/mesa-llvm
printf "\n"
printf "A very basic mesa script\n\n"
wget -q https://raw.githubusercontent.com/Cifer025/Mesa-LLVM/master/functions.sh
source ./functions.sh
printf "\e[4mOptions\n\n\e[0m"
printf "1)Install\n2)Update\n3)Exit\n"
read -p "Select the option: "  choice
if [ $choice -eq 1 ]; then 
    mesa_install
elif [ $choice -eq 2 ]; then
   mesa_update
elif [ $choice -eq 3 ]; then
    exit
fi    

sudo rm -rf /tmp/mesa-llvm
