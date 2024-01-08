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

if [[ $i -ge 10 ]]; then
    echo "No AMD GPU found"
fi

GPU_NAME=$(glxinfo -B | awk '/Device: / { print $0 }' | grep -oP '(?<=Device: ).*?(?=\()')
GPU_USAGE=$(cat /sys/class/hwmon/hwmon$i/device/gpu_busy_percent)
GPU_TEMP=$(cat /sys/class/hwmon/hwmon$i/temp1_input | awk '{print $1/1000}')
GPU_MEM_USED=$(cat /sys/class/hwmon/hwmon$i/device/mem_info_vram_used | awk '{print $1/1024/1024/1024}' | LC_ALL=C xargs printf "%.*f\n" "1")
GPU_MEM_TOTAL=$(cat /sys/class/hwmon/hwmon$i/device/mem_info_vram_total | awk '{print $1/1024/1024/1024}' | LC_ALL=C xargs printf "%.*f\n" "1")

echo "$GPU_NAME  |  $GPU_USAGE%   |  $GPU_TEMP°C   |  ${GPU_MEM_USED}G/${GPU_MEM_TOTAL}G "
