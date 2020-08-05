#!/bin/bash
#Prepare installer
cd /tmp && mkdir mesa-llvm
cd mesa-llvm
wget -q https://raw.githubusercontent.com/Cifer025/Mesa-LLVM/master/functions.sh
source ./functions.sh
#Start screen
home () {
printf "\nA very basic mesa + llvm installer\n\n"
printf "\e[4mOptions\n\n\e[0m"
printf "1) Install\n2) Update\n3) Exit\n\n"
read -p "Select an option: "  choice
if [ "$choice" = 1 ]; then 
   distro
elif [ "$choice" = "2" ]; then
   mesa_update
elif [ "$choice" = "3" ]; then
   rm -rf /tmp/mesa-llvm
   printf "Exiting...\n"
   exit
fi   
} 
home
