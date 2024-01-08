#!/bin/bash

# Get current active sink
CURRENT_SINK=$(pactl list sinks | awk '/RUNNING/ { getline; print $0}')
USB_DEVICE=$(lsusb | awk '/HyperX/')

# Set external speakers as output if USB headet is currently master
if [[ $CURRENT_SINK == *"Kingston_HyperX_Virtual_Surround_Sound"* ]]; then
    pactl set-card-profile alsa_card.pci-0000_0f_00.4 output:analog-stereo
    pactl set-card-profile alsa_card.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00 off
    pactl set-default-sink alsa_output.pci-0000_0f_00.4.analog-stereo.2
# Set USB headset as output if external speakers are currently master
else
    if [[ $USB_DEVICE == *"HyperX"* ]]; then
        pactl set-card-profile alsa_card.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00 output:analog-stereo
	pactl set-default-sink alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo
    fi
fi
