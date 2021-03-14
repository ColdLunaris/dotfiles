#!/bin/bash

IMAGE=/tmp/screen_locked.png
SCREENSHOT="scrot  $IMAGE"
BLURTYPE="0x8"

$SCREENSHOT
convert $IMAGE -scale 10% -scale 1000% $IMAGE
convert $IMAGE -blur $BLURTYPE $IMAGE
i3lock -d -i $IMAGE --ignore-empty-password --show-failed-attempts --nofork ; systemctl sleep
rm $IMAGE
