#!/bin/bash

# Start XVFB
Xvfb :1 -screen 0 1024x768x16 &

# Set the display for Wine to use the virtual framebuffer
export DISPLAY=:1

# Workaround until we can figure out how to edit wine's PATH
cp /opt/kyber/vivoxsdk.dll /mnt/battlefront

./kyber_cli start_server --server-name Test --show-console --credentials=$MAXIMA_CREDENTIALS --token $KYBER_TOKEN --game-path /mnt/battlefront/starwarsbattlefrontii.exe --verbose
