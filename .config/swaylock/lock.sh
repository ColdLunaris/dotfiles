#!/bin/bash
swaymsg "output * dpms off"
openrgb -d 0 -m static -c 000000
ckb-next -p main -m off
ratbagctl warbling-mara led 0 set color 000000
