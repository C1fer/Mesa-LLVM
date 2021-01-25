#!/bin/bash
#Prepare installer
if [ -d "/tmp/mesa-llvm" ]; then
  cd /tmp/mesa-llvm
else 
  mkdir /tmp/mesa-llvm && cd /tmp/mesa-llvm
  wget -q https://raw.githubusercontent.com/Cifer025/Mesa-LLVM/master/functions.sh
fi
. ./functions.sh
#Start screen
home () {
printf "\nA very simple mesa-git and llvm-git installer\n\n"
printf "\e[1;4mOptions\n\n\e[0m"
printf "1) Install\n2) Update\n3) Exit\n\n"
read -p "Select an option: "  choice
if [ "$choice" = 1 ]; then 
   check_repo
   clear
   distro
elif [ "$choice" = "2" ]; then
   mesa_update
elif [ "$choice" = "3" ]; then
   printf "Exiting...\n"
   exit
fi   
} 
home

