#!/bin/bash
input() {
wget -q https://raw.githubusercontent.com/Cifer025/Mesa-LLVM/master/functions.sh
source ./functions.sh
printf "A very basic mesa script\n\n"
printf "Choose an option\n\n"
printf "1)Install\n2)Update\n3)Exit\nOptions:"
read choice 
if [ $choice -eq 1 ]; then 
    mesa_install
elif [ $choice -eq 2 ]; then
   mesa_update
elif [ $choice -eq 3 ]; then
    exit
fi    
}
input


