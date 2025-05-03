{hostName, ...}: {
  networking = {
    inherit hostName;

    networkmanager.enable = true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    firewall.allowedTCPPorts = [8000];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [36969];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
