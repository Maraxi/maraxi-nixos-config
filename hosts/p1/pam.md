# enable fingerprint sensor in pam

Optionally update / restore settings with

    sudo pam-auth-update --force

## Affected files in /etc/pam.d/

i3lock

    # PAM configuration file for the i3lock screen locker. By default, it includes
    # the 'login' configuration file (see /etc/pam.d/login)
    #
    auth      sufficient pam_fprintd.so timeout=5
    auth include login

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
