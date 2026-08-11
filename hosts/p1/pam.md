Changes have been made to enable fingerprint sensor in pam.

Restore the defaults with:

    pam-auth-update --force

Affected files in /etc/pam.d/

    - i3lock
    # PAM configuration file for the i3lock screen locker. By default, it includes
    # the 'login' configuration file (see /etc/pam.d/login)
    #
    auth      sufficient pam_fprintd.so timeout=5
    auth include login

    - sudo
    #%PAM-1.0

    # Set up user limits from /etc/security/limits.conf.
    auth      sufficient pam_fprintd.so timeout=5
    session    required   pam_limits.so

    session    required   pam_env.so readenv=1 user_readenv=0
    session    required   pam_env.so readenv=1 envfile=/etc/default/locale user_readenv=0

    @include common-auth
    @include common-account
    @include common-session-noninteractive

    - common-auth
    # /etc/pam.d/common-auth - authentication settings common to all services
    #
    # This file is included from other service-specific PAM config files,
    # and should contain a list of the authentication modules that define
    # the central authentication scheme for use on the system
    # (e.g., /etc/shadow, LDAP, Kerberos, etc.).  The default is to use the
    # traditional Unix authentication mechanisms.
    #
    # As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
    # To take advantage of this, it is recommended that you configure any
    # local modules either before or after the default block, and use
    # pam-auth-update to manage selection of other modules.  See
    # pam-auth-update(8) for details.

    # here are the per-package modules (the "Primary" block)
    # auth	[success=3 default=ignore]	pam_fprintd.so max-tries=1 timeout=10 # debug
    auth	[success=2 default=ignore]	pam_unix.so nullok try_first_pass
    auth	[success=1 default=ignore]	pam_sss.so use_first_pass
    # here's the fallback if no module succeeds
    auth	requisite			pam_deny.so
    # prime the stack with a positive return value if there isn't one already;
    # this avoids us returning an error just because nothing sets a success code
    # since the modules above will each just jump around
    auth	required			pam_permit.so
    # and here are more per-package modules (the "Additional" block)
    auth	optional pam_intune.so
    auth	required	pam_ecryptfs.so unwrap
    auth	optional			pam_cap.so
    # end of pam-auth-update config
