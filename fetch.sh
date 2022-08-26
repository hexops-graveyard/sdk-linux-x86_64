#!/usr/bin/env bash
set -ex

mirror='https://ftp.halifax.rwth-aachen.de'

rm -rf root/
mkdir -p root/

declare -a packages=(
    "$mirror/ubuntu/pool/main/libx/libxkbcommon/libxkbcommon-dev_0.10.0-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libx11/libx11-6_1.6.9-2ubuntu1.3_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libx11/libx11-dev_1.7.5-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libx11/libx11-xcb-dev_1.6.9-2ubuntu1.3_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxcb/libxcb1_1.14-2_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxcb/libxcb1-dev_1.14-2_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxcursor/libxcursor-dev_1.2.0-2_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxrandr/libxrandr-dev_1.5.2-0ubuntu1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxrender/libxrender-dev_0.9.10-1.1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxinerama/libxinerama-dev_1.1.4-2_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxi/libxi-dev_1.7.10-0ubuntu1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxext/libxext-dev_1.3.4-0ubuntu1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxfixes/libxfixes-dev_5.0.3-2_amd64.deb"
    "$mirror/ubuntu/pool/main/x/xorgproto/x11proto-dev_2019.2-1ubuntu1_all.deb"
    "$mirror/ubuntu/pool/main/m/mesa/mesa-common-dev_20.0.8-0ubuntu1~18.04.1_amd64.deb"
    "$mirror/ubuntu/pool/main/w/wayland/libwayland-dev_1.16.0-1ubuntu1.1~18.04.3_amd64.deb"
)

mkdir -p deb/
for i in "${packages[@]}"
do
    echo "$i"
    deb="deb/$(basename $i)"
    if [ ! -f "$deb" ]; then
        curl -Ls "$i" > "$deb"
    fi
    ar vx "$deb"

    if [ -f ./data.tar.zst ]; then
        tar -xvf data.tar.zst -C root/
    elif [ -f ./data.tar.xz ]; then
        tar -xvf data.tar.xz -C root/
    else
        tar -xvf data.tar.gz -C root/
    fi

    rm -rf *.tar* debian-binary
done

# Remove files that are not useful as part of the SDK.
rm -rf root/usr/share/man
rm -rf root/usr/lib/x86_64-linux-gnu/pkgconfig
rm -rf root/usr/share/bug
rm -rf root/usr/share/wayland
rm -rf root/usr/share/pkgconfig
rm -rf root/usr/share/lintian
find root/usr/share/doc -type f -not -name 'copyright' | xargs rm -rf --
find root/usr/share/doc | grep changelog.Debian.gz | xargs rm --

# Eliminate symlinks, which are difficult to use on Windows.
pushd root/usr/lib/x86_64-linux-gnu

# Most of these libs are resolved at runtime by GLFW, so we only need headers.
rm  libX11.so libX11.so.6 libX11.a \
    libxcb.so libxcb.so.1 libxcb.a \
    libX11-xcb.so libX11-xcb.a \
    libXcursor.so libXcursor.a \
    libXext.so libXext.a \
    libXfixes.so libXfixes.a \
    libXi.so libXi.a \
    libXinerama.so libXinerama.a \
    libXrandr.so libXrandr.a \
    libXrender.so libXrender.a \
    libxkbcommon* \
    libwayland*

mv libX11.so.6.3.0 libX11.so
mv libxcb.so.1.1.0 libxcb.so

popd

# Vulkan headers
git clone -b v1.3.224 --depth 1 https://github.com/KhronosGroup/Vulkan-Headers
cp -R ./Vulkan-Headers/include/vulkan root/usr/include/vulkan
cp -R ./Vulkan-Headers/include/vk_video root/usr/include/vk_video
mkdir -p root/usr/share/doc/libvulkan-dev/
cp ./Vulkan-Headers/LICENSE.txt root/usr/share/doc/libvulkan-dev/
rm -rf Vulkan-Headers/