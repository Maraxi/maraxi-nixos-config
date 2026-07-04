#! /usr/bin/env bash

[[ $(id -u) -gt 0 ]] && {
	echo "please run with sudo"
	exit 1
}

cat >/etc/udev/rules.d/50-zsa.rules <<-end
	# Rules for Oryx web flashing and live training
	KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
	KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

	# Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
	# SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
	# Keymapp Flashing rules for the Voyager
	SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
end

cat >/etc/udev/rules.d/80-shokz.rules <<-end
	# 1. Block the buggy virtual power-button signals (HID interface)
	SUBSYSTEM=="usb", ATTRS{idVendor}=="3511", ATTRS{idProduct}=="2ef2", DRIVER=="usbhid", ATTR{authorized}="0"

	# 2. Prevent the device from cycling/crashing during power transitions (Entire USB device)
	ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="3511", ATTR{idProduct}=="2ef2", ATTR{power/control}="on"
end

udevadm control --reload-rules && udevadm trigger
