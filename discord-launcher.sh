#!/bin/sh

electron=electron@ELECTRON_VER@

if [ "$XDG_SESSION_TYPE" = wayland ]; then
  # Using wayland
  exec $electron \
    --enable-features=UseOzonePlatform \
    --ozone-platform=wayland \
    --enable-accelerated-mjpeg-decode \
    --enable-accelerated-video \
    --ignore-gpu-blacklist \
    --enable-native-gpu-memory-buffers \
    --enable-gpu-rasterization \
    --enable-gpu \
    --enable-features=WebRTCPipeWireCapturer \
    /usr/share/discord/resources/app.asar $@
else
  # Using x11
  exec $electron \
    --enable-accelerated-mjpeg-decode \
    --enable-accelerated-video \
    --ignore-gpu-blacklist \
    --enable-native-gpu-memory-buffers \
    --enable-gpu-rasterization \
    --enable-gpu \
    /usr/share/discord/resources/app.asar $@
fi
