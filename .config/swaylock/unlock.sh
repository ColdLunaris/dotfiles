#!/bin/bash
ckb-next -p main -m blue
ratbagctl warbling-mara led 0 set color 03FDFC
openrgb -d 0 -m static -c 03FDFC
swaymsg "output * dpms on"
