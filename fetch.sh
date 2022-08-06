#!/usr/bin/env bash
set -ex

mirror='http://mirrors.kernel.org'

rm -rf root/
mkdir -p root/

declare -a packages=(
    "$mirror/ubuntu/pool/main/libx/libx11/libx11-6_1.6.4-3ubuntu0.4_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libx11/libx11-dev_1.6.4-3ubuntu0.4_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libx11/libx11-xcb-dev_1.6.4-3ubuntu0.4_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxcb/libxcb1_1.13-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxcb/libxcb1-dev_1.13-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxcursor/libxcursor-dev_1.1.15-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxrandr/libxrandr-dev_1.5.1-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxinerama/libxinerama-dev_1.1.3-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxi/libxi-dev_1.7.9-1_amd64.deb"
    "$mirror/ubuntu/pool/main/m/mesa/mesa-common-dev_19.2.8-0ubuntu0~18.04.2_amd64.deb"
    "$mirror/ubuntu/pool/main/v/vulkan-loader/libvulkan-dev_1.2.131.2-1_amd64.deb"
    "$mirror/ubuntu/pool/main/x/xorgproto/x11proto-dev_2018.4-4_all.deb"
    "$mirror/ubuntu/pool/main/libx/libxrender/libxrender-dev_0.9.10-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxext/libxext-dev_1.3.3-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxfixes/libxfixes-dev_5.0.3-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxau/libxau-dev_1.0.8-1_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxdmcp/libxdmcp-dev_1.1.2-3_amd64.deb"
    "$mirror/ubuntu/pool/main/libx/libxkbcommon/libxkbcommon-dev_0.8.0-1ubuntu0.1_amd64.deb"
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

    if [ -f ./data.tar.xz ]; then
        tar -xvf data.tar.xz -C root/
    else
        tar -xvf data.tar.gz -C root/
    fi

    rm -rf *.tar.xz *.tar.gz debian-binary
done

# Remove files that are not useful as part of the SDK.
rm -rf root/usr/share/man
rm -rf root/usr/lib/x86_64-linux-gnu/pkgconfig
rm -rf root/usr/share/bug
rm -rf root/usr/share/wayland
rm -rf root/usr/share/pkgconfig
rm -rf root/usr/share/lintian
rm -rf root/usr/share/vulkan/registry/
find root/usr/share/doc -type f -not -name 'copyright' | xargs rm -rf --
find root/usr/share/doc | grep changelog.Debian.gz | xargs rm --

# Eliminate symlinks, which are difficult to use on Windows.
pushd root/usr/lib/x86_64-linux-gnu

rm libX11.so libX11.so.6
mv libX11.so.6.3.0 libX11.so
rm libX11.a # libX11 is dynamically linked.

rm libxcb.so libxcb.so.1
mv libxcb.so.1.1.0 libxcb.so
rm libxcb.a # libxcb is dynamically linked.

# We statically link as much as possible; so we don't need these dynamic libs.
rm libXi.so \
    libXcursor.so \
    libXrandr.so \
    libXdmcp.so \
    libXext.so \
    libXrender.so \
    libXau.so \
    libXinerama.so \
    libXfixes.so \
    libvulkan.so \
    libX11-xcb.so

rm libwayland*.so

# libxkbcommon is resolved at runtime by GLFW, so we only need headers.
rm libxkbcommon*
