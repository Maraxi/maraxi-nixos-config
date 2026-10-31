# Workaround: MT7925 (mt7925e) loses connectivity when TDLS setup with a peer
# on the same AP fails ("TDLS: Failed to set TPK to the driver").
# tdls_disabled can only be set at runtime via the control interface, so expose
# one with -O and set it from a NetworkManager dispatcher script on every "up".
# wpa_supplicant is chrooted to /run/wpa_supplicant and must be able to reply to
# the client socket, so wpa_cli runs as the wpa_supplicant user.
{ lib, pkgs, ... }: {
  systemd.services.wpa_supplicant.serviceConfig.ExecStart = lib.mkForce
    "${pkgs.wpa_supplicant}/bin/wpa_supplicant -s -u -Dnl80211,wext -c /etc/wpa_supplicant/imperative.conf -O /run/wpa_supplicant";

  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "disable-tdls" ''
        [ "$2" = up ] || exit 0
        [ -S "/run/wpa_supplicant/$1" ] || exit 0
        ${pkgs.coreutils}/bin/install -d -o wpa_supplicant -g wpa_supplicant -m 700 /run/wpa_supplicant/client
        ${pkgs.util-linux}/bin/runuser -u wpa_supplicant -- \
          ${pkgs.wpa_supplicant}/bin/wpa_cli -p /run/wpa_supplicant -i "$1" set tdls_disabled 1 2>&1 \
          | ${pkgs.util-linux}/bin/logger -t disable-tdls
      '';
    }
  ];
}
