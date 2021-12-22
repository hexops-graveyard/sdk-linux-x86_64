#!/usr/bin/env bash
set -ex

# Generates Wayland client protocol sources needed for e.g. GLFW
# https://github.com/glfw/glfw/blob/6281f498c875f49d8ac5c5a02d968fb1792fd9f5/src/CMakeLists.txt#L98-L118

# TODO: actually generate wayland-protocol sources

# Cleanup XML files we no longer need.
rm -rf root/usr/share/wayland-protocols
