#!/bin/bash

mesa_install () {
echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal main" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main" | sudo tee -a /etc/apt/sources.list
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421 
sudo apt update
sudo apt-get install -y mesa-utils meson build-essential git libvdpau-dev libxxf86vm-dev libxdamage-dev libxshmfence-dev libelf-dev libomxil-bellagio-dev libunwind-dev libglvnd-dev lm-sensors libclc-dev glslang-dev glslang-tools libva-dev vulkan-utils libpciaccess-dev wayland-protocols libwayland-egl-backend-dev libxcb-glx0-dev libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libsensors-dev zstd  && sudo apt-get -y build-dep mesa
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
printf "Installation finished. Do you want to reboot your pc? [Y]/[N]"
read choice
if [ "$choice" = "Y" ]; then
  rm -rf /tmp/mesa-llvm
  reboot 
else 
     rm -rf /tmp/mesa-llvm
     exit
fi
}

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
printf "Update finished. Do you want to reboot your pc [Y]\[N]?"
read choice
if [ "$choice" = "Y" ]; then
  rm -rf /tmp/mesa-llvm
  reboot 
else 
     rm -rf /tmp/mesa-llvm
     exit
fi
}


