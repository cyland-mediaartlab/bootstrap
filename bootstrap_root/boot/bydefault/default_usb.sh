#!/bin/bash
 
echo "Default usb script, play all by omxplayer"
while true; do
    find /usbflash/ -maxdepth 1 -type f -exec echo "play {}" \; -exec omxplayer -o local {} \;
    sleep 1s
done
