{hostName, ...}: {
  networking = {
    inherit hostName;

    networkmanager.enable = true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall.enable = true;
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [8000];
    # firewall.allowedUDPPorts = [ ... ];

    # nftables instead of iptbles for firewall
    nftables.enable = true;

    hosts = {
      "104.26.10.35" = ["static1.e621.net"];
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = false;
    ports = [36969];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
