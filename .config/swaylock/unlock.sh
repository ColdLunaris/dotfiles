#!/bin/bash
MOUSE=$(ratbagctl | sed 's/ *\:.*//')

ckb-next -p main -m blue &
ratbagctl $MOUSE led 0 set color 03FDFC &
flatpak run org.openrgb.OpenRGB -d "ASUS ROG STRIX X570-F GAMING" -z 0 -m static -c 03FDFC &
swaymsg "output * dpms on" &

wait
