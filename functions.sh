#!/bin/sh
#Full mesa installation
mesa_install () {
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
sudo apt update -y
sudo apt install -y mesa-utils meson build-essential git libvulkan-dev libvdpau-dev libxxf86vm-dev libxdamage-dev libxrandr-dev libzstd-dev libxext-dev libxshmfence-dev bison python python3-pip cmake libelf-dev libomxil-bellagio-dev libunwind-dev libglvnd-dev lm-sensors libclc-dev glslang-dev glslang-tools libva-dev vulkan-utils libpciaccess-dev wayland-protocols libwayland-egl-backend-dev libxcb-glx0-dev libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libsensors-dev zstd flex libxcb-shm0-dev llvm-12 libllvm12 clang-12 libclang-12-dev && pip3 install mako
#Build & install libdrm
if [ -d "/tmp/mesa-llvm/drm" ]; then
  cd drm 
  :
else  
  git clone https://gitlab.freedesktop.org/mesa/drm.git && cd drm
  :
fi
meson build/ 
sudo ninja -C build/ install
#Build and install libgvlnd
cd ..
if [ -d "/tmp/mesa-llvm/libglvnd" ]; then
  cd libglvnd
  :
else 
  git clone https://github.com/NVIDIA/libglvnd.git && cd libglvnd
  :
fi
meson build/
sudo ninja -C build/ install
#Install llvm-git

#Build & install mesa-git
cd ..
if [ -d "/tmp/mesa-llvm/mesa" ]; then
  cd mesa
  :
else 
  git clone https://gitlab.freedesktop.org/mesa/mesa.git && cd mesa
  :
fi
touch custom-llvm.ini
echo "[binaries]
llvm-config = '/usr/bin/llvm-config-12'" | tee custom-llvm.ini >&-
meson setup build \
       --native-file custom-llvm.ini \
       -D b_ndebug=true \
       -D b_lto=true \
       -D buildtype=plain \
       --wrap-mode=nofallback \
       -D prefix=/usr \
       -D sysconfdir=/etc \
       -D platforms=x11,wayland \
       -D dri-drivers=i915,i965,r200,r100,nouveau \
       -D gallium-drivers=r300,r600,radeonsi,nouveau,svga,swrast,virgl,iris,zink \
       -D vulkan-drivers=amd,intel,swrast \
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
       -D osmesa=true \
       -D shared-glapi=enabled \
       -D gallium-opencl=icd \
       -D valgrind=disabled \
       -D vulkan-overlay-layer=true \
       -D vulkan-device-select-layer=true \
       -D tools=[] \
       -D zstd=enabled \
       -D microsoft-clc=disabled
       
meson configure build/
ninja -C build/
if [ $? -ne 0 ]; then 
  printf '\e[1;32mCompilation failed. Exiting...'
  exit
else
  :
fi  
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
sudo apt update -y
#Update mesa
git clone https://gitlab.freedesktop.org/mesa/mesa.git && cd mesa
touch custom-llvm.ini
echo "[binaries]
llvm-config = '/usr/bin/llvm-config-12'" | tee custom-llvm.ini
meson setup build \
       --native-file custom-llvm.ini \
       -D b_ndebug=true \
       -D b_lto=true \
       -D buildtype=plain \
       --wrap-mode=nofallback \
       -D prefix=/usr \
       -D sysconfdir=/etc \
       -D platforms=x11,wayland \
       -D dri-drivers=i915,i965,r200,r100,nouveau \
       -D gallium-drivers=r300,r600,radeonsi,nouveau,svga,swrast,virgl,iris,zink \
       -D vulkan-drivers=amd,intel,swrast \
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
       -D osmesa=true \
       -D shared-glapi=enabled \
       -D gallium-opencl=icd \
       -D valgrind=disabled \
       -D vulkan-overlay-layer=true \
       -D vulkan-device-select-layer=true \
       -D tools=[] \
       -D zstd=enabled \
       -D microsoft-clc=disabled
       
meson configure build/
ninja -C build/
if [ $? -ne 0 ]; then 
  printf '\e[1;32mCompilation failed. Exiting...'
  exit
else
  :
fi  
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
printf "A very simple mesa-git and llvm-git installer\n\n"
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
  echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch main
  deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" | sudo tee -a /etc/apt/sources.list >&-
  mesa_install
elif [ "$debianver" = "2" ]; then
  echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster main
  deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster main" | sudo tee -a /etc/apt/sources.list >&-
  mesa_install
elif [ "$debianver" = "3" ]; then
  echo "deb http://apt.llvm.org/unstable/ llvm-toolchain main
  deb-src http://apt.llvm.org/unstable/ llvm-toolchain main" | sudo tee -a /etc/apt/sources.list >&-
  mesa_install
elif [ "$debianver" = "4" ]; then
  clear
  distro 

fi  
}  

#Ubuntu versions
ubuntu () {
ubuntuver=$(grep 'UBUNTU_CODENAME' /etc/os-release | sed 's/.*=//')
if [ "$ubuntuver" = "xenial" ]; then
   echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main
   deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" | sudo tee -a /etc/apt/sources.list >&-
   mesa_install
elif [ "$ubuntuver" = "bionic" ]; then
    echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main
    deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" | sudo tee -a /etc/apt/sources.list >&-
    mesa_install
elif [ "$ubuntuver" = "focal" ]; then    
    echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal main
    deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main" | sudo tee -a /etc/apt/sources.list >&-
    mesa_install
elif [ "$ubuntuver" = "groovy" ]; then    
    echo "deb http://apt.llvm.org/groovy/ llvm-toolchain-groovy main
    deb-src http://apt.llvm.org/groovy/ llvm-toolchain-groovy main" | sudo tee -a /etc/apt/sources.list >&-
    mesa_install
elif [ "$ubuntuver" = "hirsute" ]; then    
    echo "deb http://apt.llvm.org/hirsute/ llvm-toolchain-hirsute main
    deb-src http://apt.llvm.org/hirsute/ llvm-toolchain-hirsute main" | sudo tee -a /etc/apt/sources.list >&-
    mesa_install   
else
     printf '$ubuntuver is not a compatible Ubuntu release.'
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
