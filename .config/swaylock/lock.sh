#!/bin/bash
MOUSE=$(ratbagctl | sed 's/ *\:.*//')

swaymsg "output * dpms off"
openrgb -d 0 -m static -c 000000
ckb-next -p main -m off
ratbagctl $MOUSE led 0 set color 000000
