#!/bin/bash
MOUSE=$(ratbagctl | sed 's/ *\:.*//')

ckb-next -p main -m orange\/brown &
ratbagctl $MOUSE led 0 set color 591E01 &
flatpak run org.openrgb.OpenRGB -d "ASUS ROG STRIX X570-F GAMING" -z 0 -m static -c 591E01 &
swaymsg "output * dpms on" &

wait
