# enable fingerprint sensor in pam

Optionally update / restore settings with

    sudo pam-auth-update --force

## Affected files in /etc/pam.d/

sudo

    #%PAM-1.0

    # Set up user limits from /etc/security/limits.conf.
    auth       sufficient pam_fprintd.so timeout=5
    session    required   pam_limits.so

    session    required   pam_env.so readenv=1 user_readenv=0
    session    required   pam_env.so readenv=1 envfile=/etc/default/locale user_readenv=0

    @include common-auth
    @include common-account
    @include common-session-noninteractive

## For gdm

/etc/gdm3/greeter.dconf-defaults, uncomment or add

    [org/gnome/login-screen]
    enable-fingerprint-authentication=false

Run

    sudo /usr/share/gdm/generate-config

This disables fprint on login, but still allows it during lock-screen

## swaylock (Hyprland session)

swaylock is installed with `sudo apt install swaylock` (not from nix: nix' PAM cannot authenticate against the
host, home-manager's `programs.swaylock.package` is `null` on this machine). The package ships a password only
`/etc/pam.d/swaylock`, which stays as it is.

Fingerprint: not via PAM. swaylock only starts PAM after a key press, so a `pam_fprintd` line (with
`ignore-empty-password` set, as it is) never gets to check the finger without typing something first.
The `lock-screen` script (user/hyprland-ubuntu.nix, used by hypridle and the lock keybinding) starts `fprintd-verify`
in the background and unlocks swaylock with SIGUSR1 when the finger matches; the password works at any time.
`swaylock-pam-restore.sh` undoes the earlier PAM fingerprint line.
