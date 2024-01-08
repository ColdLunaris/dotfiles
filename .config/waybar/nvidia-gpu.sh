#!/bin/bash

if [[ $(lspci | grep -i NVIDIA) ]]; then
    GPU_NAME=$(nvidia-smi --format=csv,noheader --query-gpu=name)
    GPU_USAGE=$(nvidia-smi --format=csv,noheader --query-gpu=utilization.gpu | sed -r 's/^([0-9]+).*/\1/g')
    GPU_TEMP=$(nvidia-smi --format=csv,noheader --query-gpu=temperature.gpu)
    GPU_MEM_USED=$(nvidia-smi --format=csv,noheader --query-gpu=memory.used | sed -r 's/^([0-9]+).*/\1/g' | awk '{print $1/1024}' | LC_ALL=C xargs printf "%.*f\n" "1")
    GPU_MEM_TOTAL=$(nvidia-smi --format=csv,noheader --query-gpu=memory.total | sed -r 's/^([0-9]+).*/\1/g' | awk '{print $1/1024}' | LC_ALL=C xargs printf "%.*f\n" "1")

    echo "$GPU_NAME  |  $GPU_USAGE%   |  $GPU_TEMP°C   |  ${GPU_MEM_USED}G/${GPU_MEM_TOTAL}G "
else
    echo "No NVIDIA GPU found"
fi
