#!/usr/bin/env bash
# Only the power button (LNXPWRBN) may wake the machine from suspend.
# Disables every other wake source (lid, sleep button, USB, Thunderbolt, LAN, RTC, ...),
# now, at boot (systemd service) and for hotplugged devices (udev rule).

[[ $(id -u) -gt 0 ]] && {
	echo "please run with sudo"
	exit 1
}

cat >/usr/local/sbin/wake-only-power-button <<-'end'
	#!/usr/bin/env bash
	# sysfs: disable every wakeup source except the power button
	while IFS= read -r f; do
		[[ $f == */LNXPWRBN:00/* ]] && continue
		[[ $(<"$f") == enabled ]] && echo disabled >"$f" 2>/dev/null
	done < <(find /sys/devices -path '*/power/wakeup' 2>/dev/null)

	# /proc/acpi/wakeup: writing a name toggles it, so only touch enabled entries
	while read -r name _ status _; do
		[[ $status == '*enabled' ]] && echo "$name" >/proc/acpi/wakeup
	done < <(tail -n +2 /proc/acpi/wakeup)
	exit 0
end
chmod 755 /usr/local/sbin/wake-only-power-button

cat >/etc/systemd/system/wake-only-power-button.service <<-end
	[Unit]
	Description=Only allow the power button to wake from suspend

	[Service]
	Type=oneshot
	ExecStart=/usr/local/sbin/wake-only-power-button

	[Install]
	WantedBy=multi-user.target
end

cat >/etc/udev/rules.d/90-wake-only-power-button.rules <<-end
	# hotplugged devices (dock, USB, Thunderbolt) must not enable wakeup either
	ACTION=="add", SUBSYSTEM=="usb|pci|thunderbolt", ATTR{power/wakeup}=="enabled", ATTR{power/wakeup}="disabled"
end

udevadm control --reload-rules
systemctl daemon-reload
systemctl enable wake-only-power-button.service
/usr/local/sbin/wake-only-power-button

echo "remaining wake sources:"
find /sys/devices -path '*/power/wakeup' -exec grep -l '^enabled' {} +
