#!/bin/bash
#Full mesa installation
mesa_install () {
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421 
sudo apt update
sudo apt-get install -y mesa-utils meson build-essential git libvulkan-dev libvdpau-dev libxxf86vm-dev libxdamage-dev libxrandr-dev libzstd-dev libxext-dev libxshmfence-dev bison python python3-pip cmake libelf-dev libomxil-bellagio-dev libunwind-dev libglvnd-dev lm-sensors libclc-dev glslang-dev glslang-tools libva-dev vulkan-utils libpciaccess-dev wayland-protocols libwayland-egl-backend-dev libxcb-glx0-dev libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libsensors-dev zstd  && sudo apt-get -y build-dep mesa
#Build & install libdrm
wget https://dri.freedesktop.org/libdrm/libdrm-2.4.102.tar.xz
tar -xf libdrm-2.4.102.tar.xz && cd libdrm-2.4.102
meson build/ && cd build
ninja && sudo ninja install
#Install llvm
sudo apt-get install -y libllvm-12-ocaml-dev libllvm12 llvm-12 llvm-12-dev llvm-12-doc llvm-12-examples llvm-12-runtime clang-12 clang-tools-12 clang-12-doc libclang-common-12-dev libclang-12-dev libclang1-12 clang-format-12 clangd-12
#Build & install mesa-git
cd /tmp/mesa-llvm
git clone https://gitlab.freedesktop.org/mesa/mesa.git && cd mesa
touch custom-llvm.ini
echo "[binaries]" | sudo tee -a custom-llvm.ini
echo "llvm-config = '/usr/bin/llvm-config-12'" | sudo tee -a custom-llvm.ini
meson setup build \
       --native-file custom-llvm.ini \
       -D b_ndebug=false \
       -D b_lto=true \
       -D buildtype=plain \
       --wrap-mode=nofallback \
       -D prefix=/usr \
       -D sysconfdir=/etc \
       -D platforms=x11,wayland,drm \
       -D dri-drivers=i915,i965,r200,r100,nouveau \
       -D gallium-drivers=r300,r600,radeonsi,nouveau,svga,swrast,virgl,iris,zink \
       -D vulkan-drivers=amd,intel \
       -D dri3=enabled \
       -D egl=enabled \
       -D gallium-extra-hud=true \
       -D gallium-nine=true \
       -D gallium-omx=bellagio \
       -D gallium-va=enabled \
       -D gallium-vdpau=enabled \
       -D gallium-xa=enabled \
       -D gallium-xvmc=disabled \
       -D gbm=enabled \
       -D gles1=disabled \
       -D gles2=enabled \
       -D glvnd=true \
       -D glx=dri \
       -D libunwind=enabled \
       -D llvm=enabled \
       -D lmsensors=enabled \
       -D osmesa=gallium \
       -D shared-glapi=enabled \
       -D gallium-opencl=icd \
       -D valgrind=disabled \
       -D vulkan-overlay-layer=true \
       -D vulkan-device-select-layer=true \
       -D tools=[] \
       -D zstd=enabled \
       
meson configure build/
ninja -C build/
sudo ninja -C build/ install
#Reboot or exit
read -p $'\e[1;32mInstallation finished. Do you want to reboot? [Y]/[N]: \e[0m' choice
if [ "$choice" = "Y" ] ||  [ "$choice" = "y" ]; then
  rm -rf /tmp/mesa-llvm
  shutdown -r now
else 
     rm -rf /tmp/mesa-llvm
     exit
fi
}

#Mesa + llvm update
mesa_update () {
#Search for llvm updates
sudo apt-get install -y libllvm-12-ocaml-dev libllvm12 llvm-12 llvm-12-dev llvm-12-doc llvm-12-examples llvm-12-runtime clang-12 clang-tools-12 clang-12-doc libclang-common-12-dev libclang-12-dev libclang1-12 clang-format-12 clangd-12
#Update mesa
git clone https://gitlab.freedesktop.org/mesa/mesa.git && cd mesa
touch custom-llvm.ini
echo "[binaries]" | sudo tee -a custom-llvm.ini
echo "llvm-config = '/usr/bin/llvm-config-12'" | sudo tee -a custom-llvm.ini
meson setup build \
       --native-file custom-llvm.ini \
       -D b_ndebug=false \
       -D b_lto=true \
       -D buildtype=plain \
       --wrap-mode=nofallback \
       -D prefix=/usr \
       -D sysconfdir=/etc \
       -D platforms=x11,wayland,drm,surfaceless \
       -D dri-drivers=i915,i965,r200,r100,nouveau \
       -D gallium-drivers=r300,r600,radeonsi,nouveau,svga,swrast,virgl,iris,zink \
       -D vulkan-drivers=amd,intel \
       -D dri3=enabled \
       -D egl=enabled \
       -D gallium-extra-hud=true \
       -D gallium-nine=true \
       -D gallium-omx=bellagio \
       -D gallium-va=enabled \
       -D gallium-vdpau=enabled \
       -D gallium-xa=enabled \
       -D gallium-xvmc=disabled \
       -D gbm=enabled \
       -D gles1=disabled \
       -D gles2=enabled \
       -D glvnd=true \
       -D glx=dri \
       -D libunwind=enabled \
       -D llvm=enabled \
       -D lmsensors=enabled \
       -D osmesa=gallium \
       -D shared-glapi=enabled \
       -D gallium-opencl=icd \
       -D valgrind=disabled \
       -D vulkan-overlay-layer=true \
       -D vulkan-device-select-layer=true \
       -D tools=[] \
       -D zstd=enabled \
       
meson configure build/
ninja -C build/
sudo ninja -C build/ install
#Reboot or exit
read -p $'\e[1;34mUpdate finished. Do you want to reboot? [Y]/[N]: \e[0m' choice
if [ "$choice" = "Y" ] ||  [ "$choice" = "y" ]; then
  rm -rf /tmp/mesa-llvm
  shutdown -r now
else 
     rm -rf /tmp/mesa-llvm
     exit
fi
}

#Select distro
distro() {
printf "\n"
printf "A very simple mesa + llvm installer\n\n"
printf "\e[1;4mDistros\n\n\e[0m"
printf "1) Debian (Deepin, Kali, Mint DE, etc.)\n2) Ubuntu (elementary OS, Mint, Pop!_OS, etc.)\n3) Go back\n\n"
read -p "Select an option: " distro
if [ "$distro" = "1" ]; then
   debian
elif [ "$distro" = "2" ]; then  
   ubuntu
elif [ "$distro" = "3" ]; then
   clear
   home   
fi
}   

#Debian versions
debian () {
printf "\n"
printf "\e[1;4mDebian Releases\n\n\e[0m"
printf "1) Stretch (Debian 9)\n2) Buster %1s(Debian 10)\n3) Sid %4s(Unstable)\n4) Go back\n\n"
read -p "Select an option: " debianver
if [ "$debianver" = "1" ]; then
  echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" | sudo tee -a /etc/apt/sources.list
  echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" | sudo tee -a /etc/apt/sources.list
  mesa_install
elif [ "$debianver" = "2" ]; then
  echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster main" | sudo tee -a /etc/apt/sources.list
  echo "deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster main" | sudo tee -a /etc/apt/sources.list
  mesa_install
elif [ "$debianver" = "3" ]; then
  echo "deb http://apt.llvm.org/unstable/ llvm-toolchain main" | sudo tee -a /etc/apt/sources.list
  echo "deb-src http://apt.llvm.org/unstable/ llvm-toolchain main" | sudo tee -a /etc/apt/sources.list
  mesa_install
elif [ "$debianver" = "4" ]; then
  clear
  distro 

fi  
}  

#Ubuntu versions
ubuntu () {
printf "\n"
printf "\e[1;4mUbuntu Releases\n\n\e[0m"
printf "1) Xenial (16.04)\n2) Bionic (18.04)\n3) Disco%2s(19.04)\n4) Eoan%3s(19.10)\n5) Focal%2s(20.04)\n6) Go back\n\n"  
read -p "Select an option: " ubuntuver
if [ "$ubuntuver" = "1" ]; then
   echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" | sudo tee -a /etc/apt/sources.list
   echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" | sudo tee -a /etc/apt/sources.list
   mesa_install
elif [ "$ubuntuver" = "2" ]; then
    echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" | sudo tee -a /etc/apt/sources.list
    echo "deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" | sudo tee -a /etc/apt/sources.list
    mesa_install
elif [ "$ubuntuver" = "3" ]; then    
    echo "deb http://apt.llvm.org/disco/ llvm-toolchain-disco main" | sudo tee -a /etc/apt/sources.list
    echo "deb-src http://apt.llvm.org/disco/ llvm-toolchain-disco main" | sudo tee -a /etc/apt/sources.list
    mesa_install
elif [ "$ubuntuver" = "4" ]; then    
    echo "deb http://apt.llvm.org/eoan/ llvm-toolchain-eoan main" | sudo tee -a /etc/apt/sources.list
    echo "deb-src http://apt.llvm.org/eoan/ llvm-toolchain-eoan main" | sudo tee -a /etc/apt/sources.list
    mesa_install
elif [ "$ubuntuver" = "5" ]; then    
    echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal main" | sudo tee -a /etc/apt/sources.list
    echo "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main" | sudo tee -a /etc/apt/sources.list
    mesa_install   
elif [ "$ubuntuver" = "6" ]; then
     clear
     distro
    
fi
} 

#Check if llvm repository exists on /etc/apt/sources.list
check_repo () {
if grep "apt.llvm.org" /etc/apt/sources.list; then
 printf "\e[1;33mLLVM repository is already added to software sources. Please enter your password to remove it.\e[0m\n"
 sudo sed -in "/apt.llvm.org/d" /etc/apt/sources.list
else
 :
fi
}




