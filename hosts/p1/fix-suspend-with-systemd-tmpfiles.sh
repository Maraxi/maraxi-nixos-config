#!/usr/bin/env bash

[[ $(id -u) -gt 0 ]] && {
	echo "please run with sudo"
	exit 1
}

cat >/etc/tmpfiles.d/disable-usb-wakeup.conf <<-end
	w+ /proc/acpi/wakeup - - - - XHC
end

systemd-tmpfiles --create /etc/tmpfiles.d/disable-usb-wakeup.conf
