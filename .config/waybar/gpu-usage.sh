#!/bin/bash

GPU="amdgpu"

i=0
while [[ $i -lt 10 ]]; do # Never exceed more than 10 devices
    VALUE=$(cat /sys/class/hwmon/hwmon$i/name)

    if [[ "$VALUE" == "$GPU" ]]; then
	break
    fi

    let i++
done

cat /sys/class/hwmon/hwmon$i/device/gpu_busy_percent
