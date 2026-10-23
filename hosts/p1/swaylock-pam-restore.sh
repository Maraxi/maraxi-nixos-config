#!/usr/bin/env bash

# Restores the packaged /etc/pam.d/swaylock (password only, "auth include login").
# Fingerprint unlock does not use PAM: the lock-screen script (user/hyprland-p1.nix) runs fprintd-verify in
# the background and unlocks swaylock with SIGUSR1, see pam.md.

set -euo pipefail

[[ $(id -u) -gt 0 ]] && {
	echo "please run with sudo"
	exit 1
}

if [[ -e /etc/pam.d/swaylock.orig ]]; then
	mv -v /etc/pam.d/swaylock.orig /etc/pam.d/swaylock
else
	echo "no /etc/pam.d/swaylock.orig, run: sudo apt install --reinstall -o Dpkg::Options::=--force-confmiss swaylock"
fi
cat /etc/pam.d/swaylock
